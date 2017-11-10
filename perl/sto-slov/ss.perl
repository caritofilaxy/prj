{   name          => 'SS',

    min_password_length => 6,
    max_password_length => 16,

    min_username_length => 3,
    max_username_length => 16,

    min_lesson_limit => 10,
    max_lesson_limit => 1000,

    subtitles => {
        dir           => '/tmp/subtitles',
        max_size      => 0,                  # see forms/lesson/start.yml
        max_subtitles => 10_000,
    },
}
