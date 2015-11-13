#!/bin/bash

python manage.py update_db &&
python manage.py popus &&
python manage.py popme &&
python manage.py popor &&
python manage.py popco
