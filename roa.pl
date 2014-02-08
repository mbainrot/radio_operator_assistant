#!/usr/bin/perl
use Curses::UI;
use XML::Simple;
use Data::Dumper; # OPT - REMOVE ME BEFORE COMMITING
use FindBin;
use Date::Format;

START:

# Clear the screen
print `clear`;

# Check if our directory structure exists!
my $ourBasePath = $FindBin::Bin;
my $dataBasePath = "$ourBasePath/data";
my $completedPath = "$dataBasePath/completed";
my $not_sentPath = "$dataBasePath/not_sent";
my $in_progressPath = "$dataBasePath/in_progress";

print("Script path = " . $ourBasePath . "\n");

print "Checking for the base path\n";
if(-d $dataBasePath)
{
	print "- Found $dataBasePath\n";
}
else
{
	print "- Not found, creating $dataBasePath\n";
	`mkdir -p $dataBasePath`;
}

print "Checking for $completedPath\n";
if(-d $completedPath)
{
	print "- Found $completedPath\n";
}
else
{
	print "- Not found, creating $completedPath\n";
	`mkdir -p $completedPath`;
}

print "Checking for $not_sentPath\n";
if(-d $not_sentPath)
{
	print "- Found $not_sentPath\n";
}
else
{
	print "- Not found, creating $not_sentPath\n";
	`mkdir -p $not_sentPath`;
}

print "Checking for $in_progressPath\n";
if(-d $in_progressPath)
{
	print "- Found $in_progressPath\n";
}
else
{
	print "- Not found, creating $in_progressPath\n";
	`mkdir -p $in_progressPath`;
}

print "\n";
print "Folders initalised!\n";


sub processDirectory()
{
	my ($uiObj,$path,$prefix) = @_;

	my $tDir = opendir(DIR,$path) or die $!;

	while(my $file = readdir(DIR))
	{
		# Make sure its not the PWD and the upper directory nor a temp? file
		if($file ne "." and $file ne ".." and $file !~ /~/)
		{
			$targetFile = ($path . "/" . $file);
			parseFile($uiObj,$targetFile,$prefix);
		}
	}

	closedir(DIR);
}

sub parseFile()
{
	my ($uiObj,$path,$prefix) = @_;

	my $doc = new XML::Simple;

	$data = $doc->XMLin($path);
	
	# print Dumper($data); print "\n";
	
	my $msg_type = $data->{message_type};
	my $date_create = $data->{date_created};
	
	my $timeStr = time2str("[%d/%b %H:%M]",$date_create);
	my $strText = ($prefix . $timeStr);

	if($msg_type eq "INFORMAL")
	{
		# Something
		my $fullMsg = $data->{message_content}->{message};
		
		my $maxLen = 45;
		my $msgExcpt = "";

		if(length($fullMsg) > $maxLen)
		{
			$msgExcpt = (substr $fullMsg,0,$maxLen) . "...";
		}
		else
		{
			$msgExcpt = $fullMsg;
		}
		
		$strText = $strText . " - INFORMAL - " . $msgExcpt;

		
	}
	elsif($msg_type eq "FORMAL")
	{
		# Something
	}
	elsif($msg_type eq "MOVEMENT")
	{
		# Something
		my $fullMsg = $data->{message_content}->{message};
		
		my $maxLen = 45;
		my $msgExcpt = "";

		if(length($fullMsg) > $maxLen)
		{
			$msgExcpt = (substr $fullMsg,0,$maxLen) . "...";
		}
		else
		{
			$msgExcpt = $fullMsg;
		}
		
		$strText = $strText . " - MOVEMENT - " . $msgExcpt;
	}

	$uiObj->insert_at(0,$path);
	$uiObj->add_labels({ $path => $strText });
	$uiObj->layout();
	$uiObj->draw();
}

#exit;

# Clear the screen
# print `clear`;

# create a new C::UI object
my $cui = Curses::UI->new( -clear_on_exit => 1,
                       -debug => $debug,, -color_support => 0 );

# Setup the messy code
my @menu = (
    {
        -label => 'File',
        -submenu => [
		{ -label => 'New Formal Message CTRL + F', -value => \&new_formal_msg   },
		{ -label => 'New Informal Message CTRL + G', -value => \&new_informal_msg   },
		{ -label => 'New Movement Message CTRL + H', -value => \&new_movement_msg   },
		{ -label => 'Exit               CTRL + Q', -value => \&exit_dialog  }
        ]
    },

);

sub new_formal_msg()
{
	not_implemented("formal message");
}

sub new_informal_msg()
{
	not_implemented("informal message");
}

sub new_movement_msg()
{
	not_implemented("movement message");
}

sub not_implemented()
{
	$cui->error('Not implemented yet! -> ' . $_[0]);
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

# WINDOW: ACTIVE LOG ENTRIES
my $win1 = $cui->add(
	'win1', 'Window',
	-title => 'Active Log Entries (CTRL + A to focus)',
	-border => 1,
	-height => 14,
	-y    => 1,
	-bfg  => 'red',
);

# WINDOW: COMPLETED LOG ENTRIES
my $win2 = $cui->add(
	'win2', 'Window',
	-title => 'Completed Log Entries (CTRL + C to focus)',
	-border => 1,
	-y    => 15,
	-bfg  => 'blue',
);

# LISTBOX: Active Log Entries Listbox
my $listbox2 = $win1->add(
	'mylistbox', 'Listbox',
	-y => 0,
	-values    => [],
	-labels    => {},
	-onchange => \&active_entry_select,
);
# LISTBOX: Completed Log Entries Listbox
my $listbox = $win2->add(
	'mylistbox', 'Listbox',
	-values    => [],
	-labels    => {},
	-onchange => \&complete_entry_select,
);

my $dateTimeLabel = $menu->add(
	'dateTimeLabel','Label',
	-text => "Test",
	-y => 0,
	-x => -1,
	-width => 30,
	-fg => 'white',
);

sub active_entry_select()
{
	$t_lbox = $listbox2;
	$sel_id = $t_lbox->get();
	
	my $usrChoice = $cui->dialog(
		-message => 'Please choose one of the following',
		-buttons => [
			{
				-label => 'Complete',
				-value => 1,
				-shortcut => 1,
			},
			{
				-label => 'Edit',
				-value => 2,
				-shortcut => 2,
			},
			{
				-label => 'Cancel',
				-value => 3,
				-shortcut => 3,
			},
		],
	);
	
	if($usrChoice == 1)
	{
		`mv $sel_id $completedPath`;
		`touch $ourBasePath/restart.me`;
		exit;
	}
	if($usrChoice == 2)
	{
		&not_implemented("edit message");
	}
	if($usrChoice == 3)
	{
		$listbox2->focus();
	}

	$t_lbox->clear_selection();
}

sub complete_entry_select()
{
	$t_lbox = $listbox;
	$sel_id = $t_lbox->get();
	if($sel_id eq 99)
	{
		exit_dialog();
	}
	
	$t_lbox->clear_selection();
}

sub redraw_listboxes()
{
	#&flush_listboxes();

	# Populate the GUI with data
	# - Active Items, with not sent being first
	&processDirectory($listbox2, $not_sentPath,"[NOT SENT]");
	&processDirectory($listbox2, $in_progressPath,"[PENDING]");

	# - Completed Items
	&processDirectory($listbox, $completedPath,"");
}

sub update_clock()
{
	$date = `date +"\%c"`;
	$dateTimeLabel->text($date);
	$dateTimeLabel->draw;
}


# Menu Shortcuts
$cui->set_binding(sub {$menu->focus()}, "\cX");
$cui->set_binding(sub {$listbox2->focus()}, "\cA");
$cui->set_binding(sub {$listbox->focus()}, "\cC");
$cui->set_binding( \&exit_dialog , "\cQ");

# Function Shortcuts
$cui->set_binding( \&new_formal_msg, "\cF");
$cui->set_binding( \&new_informal_msg, "\cG");
$cui->set_binding( \&new_movement_msg, "\cH");

# For some random reason we want to focus the top listbox, maybe I will remember why one day...
$listbox2->focus();

# Pop our listboxes
redraw_listboxes();

$cui->set_timer('update_time',\&update_clock);
$cui->add_callback('update_time',\&update_clock);

# start the event loop
$cui->mainloop();
