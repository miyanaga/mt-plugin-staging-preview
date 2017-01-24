package MT::StagingPreview::Util;

use strict;
use warnings;
use Data::Dumper;

use base qw(Exporter);

our @EXPORT = qw(plugin pp plugin_config build);

sub plugin { MT->component('StagingPreview'); }

sub pp { print STDERR Dumper(@_); }

sub plugin_config {
    my ( $blog_id, $param ) = @_;
    my $scope = $blog_id ? "blog:$blog_id" : "system";

    my %config;
    plugin->load_config(\%config, $scope);

    my $saving = 0;
    if ( ref $param eq 'HASH' ) {
        foreach my $k ( %$param ) {
            $config{$k} = $param->{$k};
        }
        $saving = 1;
    } elsif ( ref $param eq 'CODE' ) {
        $saving = $param->(\%config);
    }

    plugin->save_config(\%config, $scope) if $saving;
    \%config;
}

sub build {
    my ( $eh, $text, $stash ) = @_;
    $stash ||= {};

    require MT::Builder;
    require MT::Template::Context;
    my $ctx = MT::Template::Context->new;
    my $builder = MT::Builder->new;

    $ctx->{__stash} = $stash;

    my $tokens = $builder->compile($ctx, $text);
    unless ( $tokens ) {
        return $eh->error($builder->errstr || 'Feild to compile.');
    }

    my $result = $builder->build($ctx, $tokens);
    unless ( defined ( $result ) ) {
        return $eh->error($builder->errstr || 'Failed to build.');
    }

    $result;
}

1;
