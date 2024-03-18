from flask import Flask

import dramatiq
from dramatiq.brokers.redis import RedisBroker

from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

class FLASK_CONFIG():
    pass


BROKER_URL = "redis:///1"

# Flask setup
app = Flask(__name__)
app.config.from_object(FLASK_CONFIG)

# Dramatiq setup
broker = RedisBroker(url=BROKER_URL)

dramatiq.set_broker(broker)

@app.route('/test', methods=["GET"])
def test():
    return {"response": "ok"}