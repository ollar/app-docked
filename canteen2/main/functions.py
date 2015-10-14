from main.database import db_session
from main.main import app
from flask import make_response, jsonify, g
from functools import wraps
import datetime

def register_api(view, endpoint, url, pk='id', pk_type='int'):
    view_func = view.as_view(endpoint)
    app.add_url_rule(url, defaults={pk: None},
                     view_func=view_func, methods=['GET', ])
    app.add_url_rule(url, view_func=view_func, methods=['POST', ])
    app.add_url_rule('%s<%s:%s>' % (url, pk_type, pk), view_func=view_func,
                     methods=['GET', 'PUT', 'DELETE'])


def _parse_user(user_obj, detailed=True):
    if not user_obj:
        return

    user = {
        'id': user_obj.id,
        'real_name': user_obj.real_name,
        'username': user_obj.username,
        'email': user_obj.email,
        # 'password': user_obj.password,
    }
    if detailed:
        user.update({
            'timestamp_created': str(user_obj.timestamp_created),
            'timestamp_modified': str(user_obj.timestamp_modified)
        })

    return user


def _parse_meal(meal_obj, detailed=True, *args, **kwargs):
    if not meal_obj:
        return

    this_month = datetime.datetime.today().month
    meal = {
        'id': meal_obj.id,
        'title': meal_obj.title,
        'category': meal_obj.category,
        'day_linked': meal_obj.day_linked,
        'source_price': meal_obj.source_price,
        'price': meal_obj.price,
    }

    if detailed:
        meal.update({
            'description': meal_obj.description,
            'enabled': meal_obj.enabled,
            'timestamp_created': meal_obj.timestamp_created,
            'timestamp_modified': meal_obj.timestamp_modified
        })

    meal.update(kwargs)

    return meal


def _parse_order(order_obj, detailed=True):
    if not order_obj:
        return

    order = {
        'id': order_obj.id,
        'user_id': order_obj.user_id,
        'order_date': str(order_obj.order_date),
        'meal_id': order_obj.meal_id,
        'quantity': order_obj.quantity,
    }

    if detailed:
        order.update({
            'timestamp_created': str(order_obj.timestamp_created),
            'timestamp_modified': str(order_obj.timestamp_modified)
        })
    return order


def _parse_comment(comment_obj, detailed=True):
    if not comment_obj:
        return

    comment = {
        'id': comment_obj.id,
        'user_id': comment_obj.user_id,
        'meal_id': comment_obj.meal_id,
        'content': comment_obj.content
    }

    if detailed:
        comment.update({
            'timestamp_created': str(comment_obj.timestamp_created),
            'timestamp_modified': str(comment_obj.timestamp_modified)
        })

    return comment


def auth_required(f, *args, **kwargs):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if not g.user:
            return make_response(jsonify({'type': 'error', 'text': 'You need to log in for that'}), 401)
        return f(*args, **kwargs)
    return wrapper


def restrict_users(f):
    """
    Checks if logged user_id equals contents user_id.
    User can edit only his profile so urls /user/ are on scope. All other urls will allow only uid == 1.
    ex: /user/15 - content uid == 15, so only user with uid == 15 or 1 are allowed.
    """
    @wraps(f)
    def wrapper(*args, **kwargs):
        user_id = kwargs.get('user_id', 0)

        if g.user and g.user.id in (1, user_id):
            return f(*args, **kwargs)
        else:
            return make_response(jsonify({'type': 'error', 'text': 'Access denied'}), 403)
    return wrapper

class Pagination():
    def __init__(self, *args, **kwargs):
        self.model = args[0]
        kwargs = {key: value.pop() for key, value in kwargs.items()}
        self.page = int(kwargs.get('page', 0))
        self.limit = int(kwargs.get('limit', 1000))

        self.overall = db_session.query(self.model).count()

    def _form_items(self):
        return db_session.query(self.model).order_by(self.model.id.desc()).all()

    def items(self):
        if self.page == 0:
            return self._form_items()
        start = (self.page - 1) * self.limit
        end = start + self.limit
        if start > self.overall:
            start = self.overall
        if end > self.overall:
            end = self.overall

        return self._form_items()[start:end]
