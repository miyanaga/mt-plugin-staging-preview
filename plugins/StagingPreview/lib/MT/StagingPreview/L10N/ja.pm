package MT::StagingPreview::L10N::ja;

use strict;
use utf8;
use base 'MT::StagingPreview::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Changes entry preview feature to custom URL or to be hidden.' => '記事のプレビュー機能をカスタムURLに変更したり、非表示にすることができます。',
    'Normal' => '通常',
    'Custom' => 'カスタム',
    'Hide' => '非表示',

    'Preview Type' => 'プレビュータイプ',
    'Custom Preview URL' => 'カスタムプレビューURL',
    'You can use Blog and Entry template tags such as mt:EntryBasename.' => 'mt:EntryBasenameなど、ブログと記事に関するテンプレートタグを利用することができます。',

    'To preview this entry, save as published first.' => 'プレビューを行うには公開状態で記事を保存してください。',
    'Preview is disabled.' => 'プレビュー機能は無効にされています。',

    'Entry Permalink' => '記事の固有URL',
    'Replace entry permalink to custom preview url.' => '記事の固有URLをプレビューURLに置き換える',
);

1;
