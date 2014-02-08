radio_operators_assistant
=========================

Simple tool to assist a radio operator in operating in a paperless environment. Uses perl and curses

One of the major goals is to provide a reliable means of recording information in a way that enables ease of data input

Features (Implemented):
~Insert features here...~

Features (Planned):

:: Message Formats ::
- Formal message recording (ala Radiogram)
- Informal Message Recording
- Unit Movement Records

All Message Types will have statuses, most messages will be "completed" by the operator on entry, but in case of a message such as an enquiry the operator can set the message to "in_progress" so that it is not forgotten. In addtion a message defaults to "not_sent" until the operator completes the message, this is to allow the recording of information and queueing of message data whilst waiting for a transmission window or for the NCS to call the operator's station.

:: Redundancy Features ::
- Audit Printing to either continious paper printer or receipt printer
- Automated backing up of data to a directory (thus allowing automatic DFS/NFS backup)
- HTTP Push to a web server of your choice


Depends:
- Perl
- CPAN
- Curses::UI and it's dependancies
- XML::Simple?

Installation:
1) Untar the script into a folder in which you have write/create permissions and then run. It will automatically create the directories that you need to be able to work.
