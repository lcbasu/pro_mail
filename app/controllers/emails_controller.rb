class EmailsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def show
    @email = Email.find(params[:id])
  end

  def reply
    reference_email = Email.find(params[:format])
    # @all_receiver_id = Array.new

    # #count = 0
    # for single in reference_email.sender_receivers
    #   @all_receiver_id.push(single.receiver_user_id)
    # end

    # @to_value = ""

    # for user_id in @all_receiver_id
    #   user = User.find(user_id)
    #   logger.debug "user: #{user}"
    #   logger.debug "user.email: #{user.email}"
    #   @to_value.concat("#{user.email},")
    # end
    @to_value = ""
    @to_value.concat("#{reference_email.user.email},")
    @sub_value = reference_email.subject
    @body_value = reference_email.body

    @email = current_user.emails.build

  end

  def forward
    reference_email = Email.find(params[:format])

    @to_value = ""
    @sub_value = reference_email.subject
    @body_value = reference_email.body

    @email = current_user.emails.build
  end

  def delete_mail
    reference_email = Email.find(params[:format])

    is_sender_deleting_the_mail = false

    if reference_email.user.id == current_user.id
      is_sender_deleting_the_mail = true
    end

    if is_sender_deleting_the_mail
      for sr in reference_email.sender_receivers
        sr.update_attributes(is_deleted_by_sender: true)
      end
    else
      for sr in reference_email.sender_receivers
        sr.update_attributes(is_deleted_by_receiver: true)
      end
    end

    redirect_to trash_url
  end

  def create
    logger.debug "params: #{params}"
    subject = params[:email][:subject]
    body = params[:email][:body]
    to = params[:recepients][:to]
    logger.debug "sub: #{subject}"
    logger.debug "body: #{body}"
    logger.debug "to: #{to}"
    receivers = to.split(",")
    unique_receivers = Set.new
    for single_receiver in receivers do
      user = User.find_by(email: single_receiver)
      if user && user.email != current_user.email
        unique_receivers.add(single_receiver)
      else
        logger.debug "No user exist with email: #{single_receiver}"
      end
    end

    logger.debug "unique_receivers size: #{unique_receivers.size}"

    if unique_receivers.size>0
      email = Email.new
      email.subject = subject
      email.body = body
      email.user = current_user
      email.is_draft = false
      if email.save
        for single_receiver in unique_receivers do
          logger.debug "single_receiver: #{single_receiver}"
          sender_receiver = SenderReceiver.new
          receiver_user = User.find_by(email: single_receiver)
          sender_receiver.email = email
          sender_receiver.sender_user_id = current_user.id
          sender_receiver.receiver_user_id = receiver_user.id
          sender_receiver.is_opened = false
          sender_receiver.is_deleted_by_sender = false
          sender_receiver.is_deleted_by_receiver = false
          sender_receiver.save
        end
      end
      redirect_to root_url
    else
      #no receiver exist
      #throw an error
      redirect_to root_url
    end

    # @email = current_user.emails.build(email_params)
    # if @email.save
    #   flash[:success] = "email created!"
    #   redirect_to root_url
    # else
    #   render root_url
    # end
  end

  def destroy
  end

  private
    def email_params
      params.require(:email).permit(:subject, :body)
    end
end
