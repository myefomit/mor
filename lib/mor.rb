require "mor/version"
require "mor/array"
require "mor/router"

module Mor
  class Application
    def call(env)

      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      klass, action = parse_route(env)
      controller = klass.new(env)

      begin
        if controller.methods.include?(action.to_sym)
          text = controller.send(action)
        else
          text = Object.const_get("DefaultController").new(env).send("action_error")
        end
      rescue => e
        raise e        
      end

      [200, {'Content-Type' => 'text/html'}, [text]]

    end
  end

  class Controller
    attr_reader :env
    
    def initialize(env)
      @env = env
    end
  end

  class DefaultController < Controller
    def controller_error
      "<h1>There is no <span style='color: red'>#{controller_name}Controller</span>!</h1>"
    end

    def action_error
      "<h1>There is no <span style='color: red'>#{action_name}</span> action!</h1>"
    end

    private

    def controller_name
      @env["PATH_INFO"].split("/", 4)[1].capitalize
    end

    def action_name
      url = @env["PATH_INFO"].split("/", 4)
      url[1].capitalize + "Controller#" + url[2]
    end
  end

end
