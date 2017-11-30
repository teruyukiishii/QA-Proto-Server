module Users
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    def omniauth_success
      get_resource_from_auth_hash
      create_token_info
      set_token_on_resource
      create_auth_params

      # 使わないのでコメントアウト
      #if resource_class.devise_modules.include?(:confirmable)
      #  # don't send confirmation email!!!
      #  @resource.skip_confirmation!
      #end

      sign_in(:user, @resource, store: false, bypass: false)

      if @resource.save!
        # update_token_authをつけることでレスポンスヘッダーに認証情報を付与できる。
        update_auth_header
        yield @resource if block_given?
        #render json: @resource, status: :ok
      else
        render json: { message: "failed to login" }, status: 500
      end

      cookies.permanent[:"access-token"] = @auth_params[:auth_token]
      cookies.permanent[:client] = @auth_params[:client_id]
      cookies.permanent[:uid] = @auth_params[:uid]
      # これをそのままつかうと304になるので一旦コメントアウト
      #render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
    end

    protected
    def get_resource_from_auth_hash
      # find or create user by provider and provider uid
      @resource = resource_class.where({
        uid:      auth_hash['uid'],
        provider: auth_hash['provider']
      }).first_or_initialize

      if @resource.new_record?
        @oauth_registration = true
        # これが呼ばれるとエラーになるのでコメントアウトする
        #set_random_password
      end

      # sync user info with provider, update/generate auth token
      assign_provider_attrs(@resource, auth_hash)

      # assign any additional (whitelisted) attributes
      extra_params = whitelisted_params
      @resource.assign_attributes(extra_params) if extra_params

      @resource
    end
  end
end
