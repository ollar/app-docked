from flask import Blueprint, jsonify, request, abort, make_response, g
from flask.views import MethodView
from sqlalchemy.exc import IntegrityError, StatementError
from main.database import db_session
from .models import Comment
from main.functions import register_api, _parse_comment, auth_required, restrict_users, Pagination
import datetime

bp_comment = Blueprint('bp_comment', __name__, url_prefix='/comment')


class CommentApi(MethodView):

    def __init__(self):
        self.json = request.get_json()

    def get(self, comment_id):
        if comment_id:
            comment = db_session.query(Comment).get(comment_id)
            if comment:
                return jsonify(_parse_comment(comment))
            else:
                return make_response(jsonify({'type': 'error', 'text': 'not found'}), 404)

        comments = Pagination(Comment, **request.args).items()
        comments[:] = [_parse_comment(comment) for comment in comments]

        return jsonify({'comments': comments})

    @auth_required
    def post(self):
        check_comment = db_session.query(Comment).filter_by(
            user_id=g.user.id, meal_id=self.json.get('meal_id')).first()
        if check_comment:
            return make_response(jsonify({'type': 'error', 'text': 'you have already commented this meal'}))
        new_comment = Comment(user_id=g.user.id,
                              meal_id=self.json.get('meal_id'),
                              content=self.json.get('content', ''))

        db_session.add(new_comment)
        db_session.commit()

        return jsonify(_parse_comment(new_comment, detailed=False))

    @auth_required
    def delete(self, comment_id):
        comment = db_session.query(Comment).get(comment_id)
        if comment:
            db_session.delete(comment)
            db_session.commit()
            return jsonify(_parse_comment(comment, detailed=False))
        return make_response(jsonify({'type': 'error', 'text': 'not found'}), 404)


@bp_comment.route('/meal/<meal_id>')
def get_meal_comments(meal_id):
    comments = db_session.query(Comment).filter_by(meal_id=meal_id).all()
    return jsonify({'comments': [_parse_comment(comment) for comment in comments]})


@bp_comment.route('/user/<user_id>')
def get_user_comments(user_id):
    comments = db_session.query(Comment).filter_by(user_id=user_id).all()
    return jsonify({'comments': [_parse_comment(comment) for comment in comments]})


register_api(CommentApi, 'comment_api', '/comment/', pk='comment_id')
