class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new :role => "1"

  end
end
