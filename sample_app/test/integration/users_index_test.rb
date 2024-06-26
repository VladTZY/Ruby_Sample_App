require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:vlad)
    @non_admin = users(:mihai)
  end

  test "index as admin including pagination and delete link" do
    log_in_as(@admin)
    
    get users_path
    assert_template 'users/index'
    
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

end
