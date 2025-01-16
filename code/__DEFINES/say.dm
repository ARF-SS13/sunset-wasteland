/*
	Defines for use in saycode and text formatting.
	Currently contains speech spans and message modes
*/



//Spans. Robot speech, italics, etc. Applied in compose_message().
#define SPAN_ROBOT "robot"
#define SPAN_YELL "yell"
#define SPAN_ITALICS "italics"
#define SPAN_SANS "sans"
#define SPAN_PAPYRUS "papyrus"
#define SPAN_REALLYBIG "reallybig"
#define SPAN_SMALL "small"
#define SPAN_SMALLER "smaller"
#define SPAN_COMMAND "command_headset"
#define SPAN_CLOWN "clown"
#define SPAN_SINGING "singing"

//bitflag #defines for return value of the radio() proc.
#define ITALICS 1
#define REDUCE_RANGE 2
#define NOPASS 4

//Eavesdropping
#define EAVESDROP_EXTRA_RANGE 1 //how much past the specified message_range does the message get starred, whispering only

// A link given to ghost alice to follow bob
#define FOLLOW_LINK(alice, bob) "<a href=?src=[REF(alice)];follow=[REF(bob)]>(F)</a>"
#define TURF_LINK(alice, turfy) "<a href=?src=[REF(alice)];x=[turfy.x];y=[turfy.y];z=[turfy.z]>(T)</a>"
#define FOLLOW_OR_TURF_LINK(alice, bob, turfy) "<a href=?src=[REF(alice)];follow=[REF(bob)];x=[turfy.x];y=[turfy.y];z=[turfy.z]>(F)</a>"

#define LINGHIVE_NONE 0
#define LINGHIVE_OUTSIDER 1
#define LINGHIVE_LING 2
#define LINGHIVE_LINK 3

//whether the emote is visible or audible.
#define EMOTE_VISIBLE 1
#define EMOTE_AUDIBLE 2

//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN			4096		//Citadel edit: What's the WORST that could happen?
#define MAX_FLAVOR_LEN			4096
#define MIN_FLAVOR_LEN			100
#define MIN_OOC_LEN				20 // Will not allow just smileys to be on OOC notes.
#define MAX_TASTE_LEN			40
#define MAX_NAME_LEN			82 // Kekekkeeke
#define MAX_BROADCAST_LEN		512
#define MAX_CHARTER_LEN			80

// Template for OOC notes.
#define OOC_NOTE_TEMPLATE "Non-ERP Notes\n\
	This exist for things like how to approach this character for IC things such as how to ask for going on adventurers!\n\
	But this person hasn't changed the info yet!\n\
	\n\
	Icebreaker!\n\
	This exists for this person to have set a quick way for you to break the IC with their character in a way that may lead to ERP, but this person hasn't changed this text to set one!\n\
	\n\
	Slavery: Ask\n\
	Non-Con: Ask\n\
	Vore: Ask\n\
	\n\
	\n\
	ERP Notes\n\
	...............Erotic Roleplay: Ask\n\
	...............Non-Con Roleplay: Ask\n\
	...............Partner Prefs: Ask\n\
	.............- Slavery: Ask\n\
	.............- Non-Con: Ask\n\
	.............- Vore: Ask\n\
	\n\
	Big Yes's\n\
	.............- This area\n\
	.............- exists to\n\
	.............- List out\n\
	.............- things you\n\
	.............- like.\n\
	\n\
	Hard No\n\
	.............- This area exists\n\
	.............- For you to list things\n\
	.............- You very specifically\n\
	.............- Do not like.\n\
	\n\
	\n\
	\n\
	***Roleplay Prefs***\n\
	Character Orientation: Ask\n\
	...Desired Post length: Ask\n\
	\n\
	...Desired RP System: Ask, this is for subtle, subtler, or emote.  Or, when its added, a mechanical erotic roleplay system!  Or some mix inbetween, but this person hasn't changed the text so ASK!\n\
	.My Post Perspective: Ask!"

#define BACKGROUND_INFO_NOTE_TEMPLATE "Background Info Template\n\
	\n\
	Remember there are no right or wrong answers when it comes to these questions, you aren’t going to fuck up.  These are to help improve the overall standard of roleplay for a new character and to help you get into the headspace of the character you are playing.  Feel free to say ‘i’m good’ on some of the answers if you don’t feel they fit.  Heck, you can even come back later after playing some to adjust it if something changes in your mind.  The bare minimum is only 40 characters per question.\n\
	\n\
	\n\  That is quite literally just one relatively short sentence.  The previous sentence was nearly 60, if that helps.\n\
	\n\
	If you are having trouble and need help feel more than free to make an ahelp or a ticket in the discord!  We WANT you to get through this, we WANT you be approved!  Hell, jabber over OOC, we want to hear your voice!\n\
	\n\
	1. What do you look like? This doesn’t need to be a full flavor text character description.  Just a snapshot of how you view them. A quick snapshot of them in any given moment.\n\
	\n\
	2. Where do you hail from?  Village? City? Which Nation? Universe and setting? Did you grow up there, move around? How did it affect you?\n\
	\n\
	3. Who are your family?  It’s something of a cliché for every character to be an orphan, so think about the alternatives. If your parents and siblings are still alive, what are they doing, and how do you get on with them?\n\
	\n\
	4. How did you enter into the work that your character does daily? Was it a profession passed down in your family for generations? Did you strike out on your own or perhaps fate forced your hand, and you had no choice?\n\
	\n\
	5. What is the most important event of your life so far? It’s possible to go a bit overboard with this. A brand new character probably hasn’t slain a thousand monsters. But there must have been something interesting to have happened to you.\n\
	\n\
	6. What is your morality? It's a sloppy system but think of D&D's alignment system.  Are you lawful good?  Neutral evil?\n\
	\n\
	7. What religion or life philosophies, if any, does your character follow? The worlds a wild place, many characters find peace in their religion or philosophical views of a land they can sometimes barely understand.  Do you?  Do you view others view in any particular way?\n\
	\n\
	8. What is your biggest flaw? One of the most important questions on this list.  Characters without flaws are not characters.  Even Superman has a weakness, and it helps to drive his stories.  We’re not saying make the most imperfect soul imaginable but people have problems.  You should as well.\n\
	\n\
	9. What is your greatest fear? Another very important question. It could be a well-known phobia like heights or spiders, or it could be much more unusual. Talk to the DM if you want to tie it to something in the campaign. These don’t have to have mechanical consequences, but they should be something you react to via roleplay.  Like a hatred for bugs or a even something as light as getting your hair wet.\n\
	\n\
	10. Who/what is your greatest foe? Perhaps you’re too carefree to make enemies, but most people have conflict with others.  Be it verbal or otherwise.  This can range from people you just don’t like based off their viewpoints to entire species of critters out in the valley because one of them ate your dog.  Be creative, but not needlessly vindictive.\n\
	\n\
	11. Are you a member of any groups? Do you have any friends you run with regularly?  Folks you like to hang out with.  Surely you have a friend or two, right?  You’ve totally touched grass. :3\n\
	\n\
	12. How do your ability scores define your personality? We have our own sets of stats but they’re not hard to understand.  Remember that they are entirely roleplay focused, so, how do your stats- high or low, effect your characters perspectives of the world or how they approach tasks.\n\
	\n\
	13. What motivates you? In particular, why do you go on adventures? Money? Stories? Proving yourself? Protecting others? Your ideals or morals?\n\
	\n\
	14. What do you most despise in others? Selfishness? Impulsiveness? Hypocrisy? Sloth? Sparkledog genetics?\n\
	\n\
	15. What is your greatest ambition? 'To defeat Lu Bu, to plumb the very depths of of the ruins themselves!' What are your goals, what are your dreams.  What do you reach for?  In an empty void of people with just yourself at the helm then where are you going?\n\
	\n\
	16. What’s the worst thing your character has ever done? It doesn’t have to be absolutely horrid, dark, or edgy, but what is the most traditionally morally awful (to yourself) thing that the character has done. How do they feel about it?  Was it justified?  Would they change it or even do it again?\n\
	\n\
	17. What is your greatest secret? Possibly the same as number 16, above. Consider who knows this secret; and how it coming out to the public might affect people’s perspective on themselves or their community.\n\
	\n\
	18. What is your character’s voice? Alec Guinness once said that he didn’t truly inhabit a character until he knew how they walked.  We have tools for setting up noises when you speak and coloring your runechat how you like.  These things help give flavor to your character but also consider how they speak.  Do they have mannerisms that they use regularly?  Do they avoid certain words that are common? \n\
	\n\
	19. What do you think of your fellow townsfolk on a general basis? The other people of the town, even if you haven’t met them, probably live rent free in your head.  How do you feel about them as strangers?  You know, super roughly.\n\
	\n\
	20. How does your character relax? Possibly a bit of an odd question, but if your character is going to be more than a horny homunculi, it’s important to think about what they’re like outside bedrooms! What are their tastes, hobbies, interests?Rake spends her relaxing time mostly curled up in tighter spaces if she's tired.  If not tired and trying to relax she's happy to hang out at the bar and get unabashedly shit faced."











	

// Is something in the IC chat filter? This is config dependent.
#define CHAT_FILTER_CHECK(T) (config.ic_filter_regex && findtext(T, config.ic_filter_regex))

// Audio/Visual Flags. Used to determine what sense are required to notice a message.
#define MSG_VISUAL (1<<0)
#define MSG_AUDIBLE (1<<1)

//Used in visible_message_flags, audible_message_flags and runechat_flags
#define EMOTE_MESSAGE (1<<0)
// Only show the overhead thing
#define ONLY_OVERHEAD (1<<1)
// Append the player's name to the front
#define PUT_NAME_IN (1<<2)
#define IS_EAVESDROP (1<<3)

#define EMOTE_HEADER_TEXT "\
	The Following Chat Functions Exist \n\
	- _text_ underlines text, +text+ bolds text, and |text| italicizes text. \n\
	-- Works in Emote, Subtle, Say, Whisper and Radio chat. \n\
	\n\
	- %text lets you siiiing. \n\
	\n\
	- @ moves your name to that position in emotes and subtles. \n\
	\n\
	- ! at the start of a radio comm to emote over the radio "
	// \n
	// We have added the following emoticons to say, add them to the end of your 'say' messages for say verb variation \n
	// :), :(, :D, ;D, :P, :O, :|, :/, :S, :*, :3, :>, :<, :C, :L, <3, :X, :#, :$,  \n
	// :@, :^), :&, :!, :?, B^U, :B, :J, >:(, >:D, >:P, >:3, >:O, >:|, >:/, >:S,  \n
//Dan is the best, <3 ~TK
//put space before the \ so it reads properly
// use \ for readability, but one big line. \n for a new line. \n\ for a new line and readability.
