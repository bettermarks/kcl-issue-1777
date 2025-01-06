protocol LoginProtocol:
    a_url: str
    b_url: str

mixin DefaultLoginMixin for LoginProtocol:
    # INFO: If no a_url, b_url is defined in the final schema, we apply the
    # value from _default_login
    a_url: str = a_url or _default_login.a_url
    b_url: str = b_url or _default_login.b_url

