{% skip_file if flag?(:api_only) %}

module Invidious::Routes::BackendSwitcher
  def self.switch(env)
    preferences = env.get("preferences").as(Preferences)
    referer = get_referer(env, unroll: false)
    saved_backend = preferences.backend_number
    backend_id = env.params.query["backend_id"]?.try &.to_i

    if backend_id.nil?
      return error_template(400, "Backend ID is required")
    end

    if saved_backend.nil?
      saved_backend = rand(CONFIG.invidious_companion.size)
    end

    env.response.cookies["PREFS"] = Invidious::User::Cookies.prefs(env.request.headers["Host"], preferences)

    env.redirect referer
  end
end
