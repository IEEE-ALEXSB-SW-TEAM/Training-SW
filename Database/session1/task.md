<a id="register"></a>

## Part 2: 
Ok our activities committee has a big problem they are lost in the dozens of excel sheets, so they decided to get help from you as a software expert.   
they wanna make a registration system for the events.   
if you attended any of our events/courses before first you fil la form to register in the event then in the event dat the reciptionist take you attendence.   
so a system like that need to store user data and event data.   
store ??????????????????????    
ok you got it we need a database here, so let's model our database first, we need to store this data:   
   
User:
- UserID
- First Name
- Last Name
- Email
- Phone Number
- Any other relevant information (e.g., address)   

Event:
- EventID
- Event Name
- Event Date
- Event Location
- Event Description
- Event Manager
- Any other relevant information

TeamMember:

- MemberID
- UserID
- CommitteeID
- Any other relevant information (e.g., role in the team)

TeamCommittee:

- CommitteeID
- CommitteeName
- HeadID
- Any other relevant information (e.g., committee name)

Registration:

- RegistrationID
- UserID
- EventID
- Registration Date
- Any other relevant information (e.g., payment details, registration status)

Attendance:

- AttendanceID 
- UserID 
- EventID 
- Attendance Date
- Any other relevant information (e.g., check-in time)   

ok show us your modeling skills and give us ERD and Relational model.
