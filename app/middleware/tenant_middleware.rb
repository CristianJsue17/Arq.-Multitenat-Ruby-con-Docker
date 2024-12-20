class TenantMiddleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      request = Rack::Request.new(env)
      subdomain = request.host.split('.').first
  
      tenant = Tenant.find_by(subdomain: subdomain)
      if tenant
        Tenant.current = tenant
      else
        return [404, {'Content-Type' => 'text/html'}, ['Tenant not found']]
      end
  
      @app.call(env)
    ensure
      Tenant.current = nil
    end
  end
  