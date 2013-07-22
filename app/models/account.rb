require IuguSDK::Engine.root.join('app', 'models', 'account')

class Account
  has_many :contacts
end
