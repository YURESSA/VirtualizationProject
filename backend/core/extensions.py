import boto3
from flask_jwt_extended import JWTManager
from flask_restx import Api
from flask_mail import Mail

from backend.core import Config

mail = Mail()

api = Api(security='BearerAuth', title="uknoAPI", description="API для сайта ukno")
api.authorizations = {
    'Bearer': {
        'type': 'apiKey',
        'name': 'Authorization',
        'in': 'header',
    }
}
api.security = [{'Bearer': []}]
jwt = JWTManager()

s3_client = boto3.client(
    "s3",
    endpoint_url=Config.ENDPOINT_URL,
    aws_access_key_id=Config.YC_ACCESS_KEY,
    aws_secret_access_key=Config.YC_SECRET_KEY
)