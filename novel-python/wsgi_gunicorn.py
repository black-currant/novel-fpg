from app import create_app

app = create_app(config_name="PRODUCTION")
app.app_context().push()