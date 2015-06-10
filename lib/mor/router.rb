module Mor
  class Application
    def parse_route(env)
      _, controller, action, after = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize
      controller += "Controller"

      begin 
        Object.const_get(controller)
      rescue
        return [Object.const_get("DefaultController"), "controller_error"]
      end

      [Object.const_get(controller), action]
    end

    def post?(env)
      env["REQUEST_METHOD"] == "POST"
    end
  end

end