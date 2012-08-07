# Wicked Focused

This gem is [wicked](https://github.com/schneems/wicked) tweaked for use with [focused controller](https://github.com/jonleighton/focused_controller).

[![Build Status](https://secure.travis-ci.org/schneems/wicked.png)](http://travis-ci.org/schneems/wicked)

Use wicked to make your Rails controllers into step-by-step wizards. To see Wicked in action check out the example [Rails app](https://github.com/schneems/wicked_example) or [watch the screencast](http://schneems.com/post/18437886598/wizard-ify-your-rails-controllers-with-wicked).

## Why

Many times I'm left wanting a RESTful way to display a step by step process that may or not be associated with a resource. Wicked gives the flexibility to do what I want while hiding all the really nasty stuff you shouldn't do in a controller to make this possible. At it's core Wicked is a RESTful(ish) state machine, but you don't need to know that, just use it.

## Install

Add this to your Gemfile

```ruby
  gem 'wicked-focused'
```

Then run `bundle install` and you're ready to start

## Quicklinks

* Build an object step-by-step using [Partial Validation of Active Record Objects](https://github.com/schneems/wicked/wiki/Partial-Validation-of-Active-Record-Objects)
* [Show Current Wizard Progress to User](https://github.com/schneems/wicked/wiki/Show-Current-Wizard-Progress-to-User)
* [Example App](https://github.com/schneems/wicked_example)
* [Screencast](http://schneems.com/post/18437886598/wizard-ify-your-rails-controllers-with-wicked)
* [Watch Railscasts episode: #346 Wizard Forms with Wicked](http://railscasts.com/episodes/346-wizard-forms-with-wicked)

## How

We are going to build an 'after signup' wizard. First create a controller:

```
  rails g controller after_signup
```

Add Routes into `config/routes.rb`:

```ruby
  resources :after_signup
```

Next include `Wicked::Wizard` in your controller

```ruby

  class AfterSignupController
    # base Wizard Action class of Controller must be called 'Action'
    # and must include of Wizard::Action
    class Action < FocusedAction
      include Wizard::Action

      steps :confirm_password, :confirm_profile, :find_friends    
    end

    # creates Focused Action :index 
    include Wicked::Wizard 

```

The wizard is set to call steps in order in the show action, you can specify custom logic in your show using a case statement like below. To send someone to the first step in this wizard we can direct them to `after_signup_path(:confirm_password)`.

```ruby
class AfterSignupController
  class Action < FocusedAction
    include Wizard::Action

    steps :confirm_password, :confirm_profile, :find_friends    
  end
  include Wicked::Wizard 

  class Show < Action
    def run
      wizard_redirect and return if super()
      @user = current_user
      case step
      when :find_friends
        @friends = @user.find_friends
      end
      render_wizard
    end
  end
end
```

**Note:** Wicked uses the `:id` parameter to control the flow of steps, if you need to have an id parameter, please use nested routes see [Partial Validation of Active Record Objects](https://github.com/schneems/wicked/wiki/Partial-Validation-of-Active-Record-Objects) for an example. It will need to be prefixed, for example a Product's `:id` would be `:product_id`

You'll need to call `render_wizard` at the end of your action to get the correct views to show up.

By default the wizard will render a view with the same name as the step. So for our controller `AfterSignupController` with a view path of `/views/after_signup/` if call the :confirm_password step, our wizard will render `/views/after_signup/confirm_password.html.erb`

Then in your view you can use the helpers to get to the next step.

```ruby
   <%= link_to 'skip', next_wizard_path %>
```

You can manually specify which wizard action you want to link to by using the wizard_path helper.

```ruby
   <%= link_to 'skip', wizard_path(:find_friends) %>
```

In addition to showing sequential views we can update elements in our controller.
Note: Here we demonstrate the use of wicked macros.

```ruby
class AfterSignupController
  use_wicked_macros
  
  wicked_base_action do
    steps :confirm_password, :confirm_profile, :find_friends
  end    

  wizard_action :show do
    wizard do
      skip_step if params[:skip_step]
      render_wizard
    end
  end  

  wizard_action :update do
    wizard do
      @user = current_user
      case step
      when :confirm_password
        @user.update_attributes(params[:user])
      end
      sign_in(@user, :bypass => true) # needed for devise
      render_wizard @user
    end
  end
end
```

We're passing `render_wizard` our `@user` object here. If you pass an object into `render_wizard` it will show the next step if the object saves or re-render the previous view if it does not save.

To get to this update action, you simply need to submit a form that PUT's to the same url

```ruby

    <%= form_for @user, :url => wizard_path, :method => :put do |f| %>
      <%=  f.password_field :password  %>
      <%=  f.password_field :password_confirmation  %>

      <%= f.submit "Change Password" %>
    <% end %>

```

We explicitly tell the form to PUT above. If you forget this, you will get a warning about the create action not existing, or no route found for POST. Don't forget this.

In the controller if you find that you want to skip a step, you can do it simply by calling `skip_step`

```ruby

  show_wizard do
    wizard do
      @user = current_user
      case step
      when :find_friends
        if @user.has_facebook_access_token?
          @friends = @user.find_friends
        else
          skip_step
        end
      end
      render_wizard
    end
  end

```

Now you've got a fully functioning AfterSignup controller! If you have questions or if you struggled with something, let me know on [twitter](http://twitter.com/schneems), and i'll try to make it better or make the docs better.

## Quick Reference

*Macros*

`use_wicked_macros` enables use of the Wicked macros. Otherwise you must explicitly create equivalent classes and methods.

`wicked_base_action name, &block`

Created the Focused Controller action base class, from which any Wizard Action class will inherit from.

`wizard_action name, &block` 

Creates a Focused Controller action class inheriting from the base action class of the controller. The block contains the class definition. The wizard actions are `show` and `update`. To further abstract this, the shorthand macros: `show_wizard` and `update_wizard` are also available.

`wizard`

Creates a `#run` method as "required" by a Focused Controller action class. The run method generated calls `super()` which calls `setup_wizard` and also auto-handles redirects.

*View/URL Helpers*

```ruby

  wizard_path                  # Grabs the current path in the wizard
  wizard_path(:specific_step)  # Url of the :specific_step
  next_wizard_path             # Url of the next step
  previous_wizard_path         # Url of the previous step

  # These only work while in a Wizard, and are not absolute paths
  # You can have multiple wizards in a project with multiple `wizard_path` calls
```

*Controller Tidbits:*

```ruby
  steps  :first, :second       # Sets the order of steps
  step                         # Gets symbol of current step
  next_step                    # Gets symbol of next step
  skip_step                    # Tells render_wizard to skip to the next logical step
  render_wizard                # Renders the current step
  render_wizard(@user)         # Shows next_step if @user.save, otherwise renders current step
```

Finally:

Don't forget to create your named views

```
  app/
   views/
    controller_name/
      first.html.erb
      second.html.erb
      # ...
```

# Finish Wizard Path

You can specify the url that your user goes to by over-riding the `finish_wizard_path` in your wizard controller action.


```
  def finish_wizard_path
    user_path(current_user)
  end
```

### Testing with RSpec

```ruby
  # Test find_friends block of show action
  get :show, :id => :find_friends

  # Test find_friends block of update action
  put :update, {'id' => 'find_friends', "user" => { "id" => @user.id.to_s }}
```

## About

Please poke around the source code, if you see easier ways to get a Rails controller do do what I want, let me know.

If you have a question file an issue or, find me on the Twitters [@schneems](http://twitter.com/schneems).

This project rocks and uses MIT-LICENSE.