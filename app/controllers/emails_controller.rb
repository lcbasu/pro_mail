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
    for sr in reference_email.sender_receivers
      user = User.find(sr.receiver_user_id)
      @to_value.concat("#{user.email},")
    end
    @to_value.concat("#{reference_email.user.email}")
    @sub_value = "[REPLY]"
    @sub_value.concat(" #{reference_email.subject}")
    @placeholder_text = "Write your reply here..."
    @body_value = ""
    @source_email_id = reference_email.id
    @draft_email_id = -1
    @email = current_user.emails.build

  end

  def forward
    reference_email = Email.find(params[:format])

    @to_value = ""
    @sub_value = "[Forward]"
    @sub_value.concat(" #{reference_email.subject}")
    @placeholder_text = "Write your message for forwarding this email here..."
    @body_value = ""
    @source_email_id = reference_email.id
    @draft_email_id = -1
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

  def save_draft
    logger.debug "params: #{params}"
    subject = params[:sub]
    body = params[:body]
    to = params[:to]
    source_email_id = params[:source_email_id]
    draft_email_id = params[:draft_email_id]
    if draft_email_id.to_i>0
      reference_email = Email.find(draft_email_id)
      reference_email.update_attributes(receivers_for_draft: to)
      reference_email.update_attributes(subject: subject)
      reference_email.update_attributes(body: body)
    else
      email = Email.new
      email.subject = subject
      email.body = body
      email.user = current_user
      email.source_email_id = source_email_id
      email.is_draft = true
      email.receivers_for_draft = to
      email.save
    end

    redirect_to draft_path
  end

  def edit_draft
    reference_email = Email.find(params[:format])
    @to_value = reference_email.receivers_for_draft
    @sub_value = reference_email.subject
    @placeholder_text = "Write your message..."
    @body_value = reference_email.body
    @source_email_id = reference_email.source_email_id
    @draft_email_id = reference_email.id
    @email = current_user.emails.build
  end

  def create
    logger.debug "params: #{params}"
    subject = params[:email][:subject]
    body = params[:email][:body]
    to = params[:recepients][:to]
    source_email_id = params[:email][:source_email_id]
    draft_email_id = params[:email][:draft_email_id]
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
      if draft_email_id.to_i>0
        email = Email.find(draft_email_id)
        email.update_attributes(subject: subject)
        email.update_attributes(body: body)
        email.update_attributes(source_email_id: source_email_id)
        email.update_attributes(is_draft: false)
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
      else
        email = Email.new
        email.subject = subject
        email.body = body
        email.user = current_user
        email.source_email_id = source_email_id
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
