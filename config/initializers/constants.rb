APP_NAME = "Olympos"
FULL_ROOT = YAML.load_file("#{Rails.root}/config/full_root.yml")[Rails.env]

FEMALE = 0
MALE = 1

NOVICE = 1
BEGINNER = 2
INTERMEDIATE = 3
ADVANCED = 4
EXPERT = 5

EMAIL = 0
FACEBOOK = 1


VALID_EMAIL = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
FACEBOOK_VALID_EMAIL = /^([\w!.%+\-])+@([\w\-])+(?:\.[\w\-]+)+$/

DEFAULT_FROM = "olympos.help@gmail.com"

WINNING_SCORE = 11
MAX_PERIODS = 5
MAX_PERIODS_TO_WIN = 3

SKILL_TOOLTIP = "How good is this guy?"
FAIRNESS_TOOLTIP = "How fair is this guy?"