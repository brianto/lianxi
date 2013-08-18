class Login < Authlogic::Session::Base
  authenticate_with User
end
