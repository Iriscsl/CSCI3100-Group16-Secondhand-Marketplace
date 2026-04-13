class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /users/confirmation?confirmation_token=xxx
  # Instead of auto-confirming, render a page with a "Confirm" button.
  # This prevents email link scanners from auto-confirming users.
  def show
    @confirmation_token = params[:confirmation_token]

    if @confirmation_token.blank?
      self.resource = resource_class.new
      resource.errors.add(:confirmation_token, :blank)
      respond_with_navigational(resource) { render :new, status: :unprocessable_entity }
      return
    end

    # Just render the confirmation landing page (don't confirm yet)
    self.resource = resource_class.new
  end

  # POST /users/confirmation
  # Actually confirm the account when the user clicks the button.
  def confirm
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end
end
