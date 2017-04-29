module HomeController
  def self.included(base)
    base.instance_eval do
      helpers do
      end

      before do
      end

      get '/home' do
        "homepage"
      end
    end

  end
end
