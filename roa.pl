#!/usr/bin/perl
use Curses::UI;

# create a new C::UI object
my $cui = Curses::UI->new( -clear_on_exit => 1,
                       -debug => $debug,, -color_support => 1 );

# Setup the messy code
my @menu = (
    {
        -label => 'File',
        -submenu => [
		{ -label => 'New Formal Message CTRL + F', -value => \&not_implemented   },
		{ -label => 'New Informal Message CTRL + I', -value => \&not_implemented   },
		{ -label => 'New Unit Movement CTRL + U', -value => \&not_implemented   },
		{ -label => 'Exit               CTRL + Q', -value => \&exit_dialog  }
        ]
    },

);

sub not_implemented()
{

}

sub exit_dialog()
{
        my $return = $cui->dialog(
                -message   => "Do you really want to quit?",
                -title     => "Are you sure???",
                -buttons   => ['yes', 'no'],

        );

exit(0) if $return;
}

my $menu = $cui->add(
                'menu','Menubar',
                -menu => \@menu,
                -fg  => "blue",

        );

my $win1 = $cui->add(
             'win1', 'Window',
             -border => 1,
         -height => 14,
             -y    => 1,
             -bfg  => 'red',

        
     );
my $win2 = $cui->add(
             'win2', 'Window',
             -title => 'Previous Log Entries',
         -border => 1,
             -y    => 15,

             -bfg  => 'blue',
         #-centered => 1,
     );

my $listbox2 = $win1->add(
        'mylistbox', 'Listbox',
    -y => 0,
        -values    => [1, 2, 3, 4, 99],
        -labels    => {
        1 => 'New Formal Message',
                2 => 'New Informal Message/Log',
                3 => 'New Unit Movement Record',
        4 => 'Blah',
        99 => 'Quit',
    },
    -onchange => \&menu_select,
        # -radio     => 1,
    );
my $listbox = $win2->add(
        'mylistbox', 'Listbox',
        -values    => [1, 2, 3],
        -labels    => { 1 => 'One',
                        2 => 'Two',
                        3 => 'Three' },
        # -radio     => 1,
    );

sub menu_select()
{
    $sel_id = $listbox2->get();
    if($sel_id eq 99)
    {
        exit_dialog();
    }   
}

$cui->set_binding(sub {$menu->focus()}, "\cX");
$cui->set_binding( \&exit_dialog , "\cQ");

 $listbox2->focus();
 #$textentry->focus();
        $cui->mainloop();

# start the event loop
$cui->mainloop;
