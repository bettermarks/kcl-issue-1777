import mod

schema Config:
    mixin [
        mod.DefaultLoginMixin
    ]

schema Stage:
    [...str]: Config
    _default_login: Config

ci00 = Stage {
    # FIXME: how is _default_login reaching the mixin, when defined in one script,
    # but not if the mixin is imported from a module?
    _default_login = Config {
        a_url = "https://default.a_url"
        b_url = "https://default.b_url"
    }
    provider_1 = Config {}
    provider_2 = Config {
        # INFO: override the default
        a_url = "https://custom.a_url"
    }
}
# the value comes from _default_login here
# b_url = "https://custom.b_url"
config = Config {
    # without a_url and b_url we get an error here
    a_url = "https://must.be.set.a_url"
    b_url = "https://must.be.set.b_url"
}
