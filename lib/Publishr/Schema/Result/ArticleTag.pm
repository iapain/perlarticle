package Publishr::Schema::Result::ArticleTag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("article_tag");
__PACKAGE__->add_columns(
  "tag_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
  "article_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("article_id", "tag_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-02-07 12:03:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:M8BObAOyOB+ugJ9pDx07Yg


#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(tag => 'Publishr::Schema::Result::Tag', 'tag_id');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(article => 'Publishr::Schema::Result::Article', 'article_id');
1;
