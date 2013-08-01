module MotionAWS
  class Config
    
    def self.credentials
      @credentials
    end
    def self.credentials=(val)
      @credentials = val
    end
    
  end
  
  module_function
  
  def config(creds={})
    MotionAWS::Config.credentials = creds
  end
end
