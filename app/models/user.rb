class User < ActiveRecord::Base
  # Requirements 
  require 'net/ldap'
  require 'securerandom'
  # Model relationships
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :accounts
  has_many :permissionusers
  has_many :permissions, through: :permissionusers
  belongs_to :account
  # Validations
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validates :username, presence: true, uniqueness: true, length: { in: 3..20 }
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX, message: "Invalid email address" }
  validate :authUser, on: :create
  # Filters
  # Attributes
  attr_accessor :password

  def checkLocalAdmin
    if self.password == "#{Continuous::Application.config.adminpassword}"
      true
    else
      false
    end
  end

  def authUserLDAP
    if checkLocalAdmin
      logger.debug("Uer is super admin")
      return true
    end
    if Continuous::Application.config.ldapenabled
      ldap = connectionLDAP
      if not ldap.bind
        logger.debug("User and Password are Invalid in LDAP")
        errors.add(:password, "Invalid username/password")
        return false
      else
        return true
      end
    else
      logger.debug("LDAP auth is not enabled")
      return false
    end
  end

  def authUserDB
    true
  end

  def authUser
    if Continuous::Application.config.ldapenabled
      authUserLDAP ? true : false
    else
      authUserDB ? true : false
    end
  end

  def setUuid
    SecureRandom.hex(20)
  end

  def ldapGetEmail
    ldap = connectionLDAP
    filter = Net::LDAP::Filter.eq("uid", self.username)
    attrs = ["mail"]
    treebase = Continuous::Application.config.ldapbase
    email = ""
    ldap.search(:base => treebase, :filter => filter, :attributes => attrs, :return_result => false) do |entry|
      entry.each do |a,v|
        if a.to_s == "mail"
          email = v[0]
        end
      end
    end
    return email
  end

  def ldapGetName
    # Using sn instead of displayName as we dont have displayName
    ldap = connectionLDAP
    filter = Net::LDAP::Filter.eq("uid",self.username)
    attrs = ["sn"]
    treebase = Continuous::Application.config.ldapbase
    displayname = ""
    ldap.search(:base => treebase, :filter => filter, :attributes => attrs, :return_result => false) do |entry|
      entry.each do |a,v|
        if a.to_s == "sn"
	  logger.debug(v.to_s)
          displayname = v[0]
        end
      end
    end
    return displayname
  end


private

  def connectionLDAP
    ldapsettings = {
      :host => Continuous::Application.config.ldap,
      :port => Continuous::Application.config.ldapport,
      #:encryption => :simple_tls,
      :base => Continuous::Application.config.ldapbase
    }
    l = Net::LDAP.new ldapsettings
    l.auth("uid=#{self.username},#{Continuous::Application.config.ldapou}", self.password)
    return l
  end

end
