class User < ActiveRecord::Base

  has_many :identities

  devise :database_authenticatable, :registerable, :trackable, :omniauthable

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.

    user = signed_in_resource ? signed_in_resource : identity.user

    email = auth.info.email.nil? ? "" : auth.info.email

    # if there's already a user with
    if user and user.email.blank? and auth.info.email
        user.email = email
        user.save!
    end

    # Create the user if needed

    if user.nil?
      # do we have a user with a matching email already?
      # if so, just use that one.

      user = User.where(:email => email).first if auth.info.email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            name: auth.extra.raw_info.name,
            email: email,
            password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def role?(role_name)
    puts "*************************"
    puts "role_name=",role_name
    puts "*************************"
    case role_name
      when :admin
        puts "is_admin?=",is_admin?
        is_admin?
      when :instructor
        is_instructor?
      when :student
        self.id != nil
      when :guest
        true
    end
  end

end
