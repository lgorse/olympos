module UsersHelper

  def save_manual_user
    if @current_user.save
      new_user_success
    else
      render 'new'
    end
  end

  def new_user_from_FB
    my_fb = @graph.get_object("me")
    print my_fb
    @attr = {:firstname => my_fb['first_name'], :lastname => my_fb['last_name'],
             :email => my_fb['email'], :gender => my_fb['gender'],
             :birthdate => Date.strptime(my_fb['birthday'], "%m/%d/%Y").year, :fb_id => my_fb['id'],
             :password => 'randompassword'}
    @current_user = User.where(:fb_id => my_fb['id']).first_or_initialize(@attr.merge(:signup_method => FACEBOOK))
    save_fb_user
  end

  def save_fb_user
    if @current_user.save
      new_user_success
    else
      render 'fb'
    end
  end


  def new_user_success
    sign_in_user
    redirect_to details_user_path(@current_user)
  end

  def current_user?(user)
    user == @current_user
  end

  def you_for_current_user(user)
    current_user?(user) ? "You" : user.firstname
  end

  def geolocalize
    @current_user.localize_by_request_location(request) if @current_user.a_location_attribute_is_missing
  end

  def skill_rating_explain(i)
    case i
    when 5
      '<b>Pro.</b>
       You have trouble finding players you can\'t beat.'
    when 4
      '<b>Expert.</b>
       You give the pros a good fight; you beat most players you encounter.'
    when 3
      '<b>Intermediate.</b>
       You have a good grasp of the game and win 50% of your matches.'
    when 2
      '<b>Beginner.</b>
       You know the rules and just need practice.'
    when 1
      '<b>Novice.</b>
       You are learning the rules and lose every game.'
    else
    end
  end

end
