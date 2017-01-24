package MT::StagingPreview::CMS;

use strict;
use warnings;

use MT::StagingPreview::Util;

sub blog_config_template {
    my ( $plugin, $param, $scope ) = @_;
    my $app = MT->instance;

    $param->{preview_types} = [
        {
            label => plugin->translate('Normal'),
            value => 'normal',
        },
        {
            label => plugin->translate('Custom'),
            value => 'custom',
        },
        {
            label => plugin->translate('Hide'),
            value => 'hide',
        },
    ];

    plugin->load_tmpl('blog_config_template.tmpl');
}

sub template_param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $config = plugin_config($param->{blog_id});
    my $preview_type = $config->{preview_type} || 'normal';
    my $status = $param->{status} || MT::Entry::HOLD();
    my $message;

    $param->{jq_js_include} ||= '';
    if ( $preview_type eq 'custom' ) {
        if ( $param->{id} && $status == MT::Entry::RELEASE() ) {
            eval {
                my $id = $param->{id};
                my $entry = MT->model('entry')->load({ id => $id });
                my $url = build(MT::ErrorHandler->new, $config->{entry_custom_preview_url}, { entry => $entry });

                $param->{jq_js_include} .= <<"EOJ";
(function() {
    jQuery('button.preview').click(function() {
        window.open('$url', 'mt-entry-$id-prewview');
        return false;
    });
})();
EOJ
            };
        } else {
            $message ||= plugin->translate('To preview this entry, save as published first.');
            $preview_type = 'hide';
        }
    }

    if ( $preview_type eq 'hide' ) {
        $message ||= plugin->translate('Preview is disabled.');
        $param->{jq_js_include} .= <<"EOJ";
(function() {
    jQuery('button.preview, #permalink-field').hide();
    jQuery('<small />').text('$message').appendTo(jQuery('#entry-publishing-widget .widget-content'));
})();
EOJ
    }

    1;
}

sub init {
    # 次のMT::Entry::permalink上書きのためのダミーフック
    return 1;
}

use MT::Entry;

{
    no warnings qw( redefine );

    my $__entry_permalink = \&MT::Entry::permalink;
    *MT::Entry::permalink = sub {
        my $entry = $_[0] || return;
        my $config = plugin_config($entry->blog_id);
        if ( $config->{replace_permalink} ) {
            build(MT::ErrorHandler->new, $config->{entry_custom_preview_url}, { entry => $entry });
        } else {
            $__entry_permalink->(@_);
        }
    };
}

1;
