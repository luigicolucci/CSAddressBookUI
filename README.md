CSAddressBookUI
===============
##Introduction 
This is an iPhone AddressBook contacts multiple selection project

Most of you at least once have been asked to have a multiple selection contact from the Address Book. 
You can find load of answers on stackoverflow telling you what to do and how to use all the Apple Assets.framework and AddressBook.framework

Few days ago I chose to develop my own Contacts Picker, same as WhatsApp does. Just shared that here. Hope can help someone.

Min iOS allowed: 5.0.

##Usage
You can find a pretty simple Sample code to follow. Just drag and drop the CSAddressBookUI framework on your project and present the Nav controller.

###E-mail

            CSPeoplePickerNavigationController *controller = [[CSPeoplePickerNavigationController alloc] initWithType:ULABContactEmail];
            controller.messageBody = @"This is a test";
            [self presentModalViewController:controller animated:YES];

###SMS
            CSPeoplePickerNavigationController *controller = [[CSPeoplePickerNavigationController alloc] initWithType:ULABContactPhone];
            controller.messageBody = @"This is a test";
            [self presentModalViewController:controller animated:YES];
            
## Comments
NOTE: please don't forget to add MessageUI.framework and AddressBook.framework as well to your project.

I'm planning to provide some other further changes and customizable stuff. Will do in a bit.
Please let me know if you can find any kind of suggestions or issue to report.

That's it. Think...

##Contact

* <link>@Luigi_Colucci</link> on twitter
* luigicolucci.mail@gmail.com

##Licence

Copyright (c) 2012 Luigi Colucci - CitySocialising

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.