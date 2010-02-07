package Publishr::Schema::Result::Article;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("article");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "title",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
  "body",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "user_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "insert_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "update_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-02-07 12:03:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7tXi2GbqfYIRiaAszJ8ong


#
# Set relationships:
#

__PACKAGE__->belongs_to(user => 'Publishr::Schema::Result::User', 'user_id');
__PACKAGE__->has_many(map_article_tags => 'Publishr::Schema::Result::ArticleTag', 'article_id');
__PACKAGE__->many_to_many(tags => 'map_article_tags', 'tag');
1;
