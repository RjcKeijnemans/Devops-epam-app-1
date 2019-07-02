import os
from flask import Flask, jsonify
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy import Column, Integer, String

user = 'api_db_user'
subname = 'server-10002' 
pwd = 'Interforaewg098!'
sub = 'server-10002.postgres.database.azure.com'
db = 'api_db'

app = Flask(__name__)

engine = create_engine("postgresql+psycopg2://{0}@{1}:{2}@{3}/{4}?sslmode=require".format(user, subname, pwd, sub, db), echo = True)

db_session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))
Base = declarative_base()
Base.query = db_session.query_property()


class ApiData(Base):
    __tablename__ = "api_data"

    id = Column(Integer, primary_key=True)
    uuid1 = Column(String(256))
    uuid2 = Column(String(256))
    uuid3 = Column(String(256))

    @property
    def serialize(self):
        return {
            'id': self.id,
            'uuid1': self.uuid1,
            'uuid2': self.uuid2,
            'uuid3': self.uuid3
        }


def get_db_api_data() -> ApiData:
    api_data = db_session.query(ApiData)
    return api_data


@app.route("/", methods=["GET"])
def app_index():
    return "Available method: get_api_data"


@app.route("/get_api_data", methods=["GET"])
def get_api_data():
    resp = jsonify(json_list=[i.serialize for i in get_db_api_data().all()])
    resp.status_code = 200
    return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)
