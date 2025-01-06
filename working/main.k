protocol LoginProtocol:
    a_url: str
    b_url: str

mixin DefaultLoginMixin for LoginProtocol:
    # INFO: If no a_url, b_url is defined in the final schema, we apply the
    # value from _default_login
    a_url: str = a_url or _default_login.a_url
    b_url: str = b_url or _default_login.b_url

schema Config:
    mixin [
        DefaultLoginMixin
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
