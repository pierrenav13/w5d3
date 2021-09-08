require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Users
    attr_accessor :fname, :lname

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                id
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def initialize(options)
        @fname = options['fname']
        @lname = options['lname']
    end
end

class Questions
    attr_accessor :title, :body, :author_id
    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless question.length > 0

        Question.new(question.first)
    end

    def initialize(options)
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end
end

class QuestionFollows
    attr_accessor :question_id, :users_id
    def self.find_by_id(id)
        question_follows = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                id
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        return nil unless question_follows.length > 0

        QuestionFollows.new(question_follows.first)
    end

    def initialize(options)
        @question_id = options['question_id']
        @users_id = options['users_id']
    end
end

class Replies
    attr_accessor :subject_id, :parent_id, :author_id, :body

    def self.find_by_id(id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                id
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless replies.length > 0

        Replies.new(replies.first)
    end

    def initialize(options)
        @subject_id = options['subject_id']
        @parent_id = options['parent_id']
        @author_id = options['author_id']
        @body = options['body']
    end
end

class QuestionLikes
    attr_accessor :question_id, :users_id



end