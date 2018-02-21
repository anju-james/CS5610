# Tasktracker

TaskTracker application based on microblog and memory projects
Reference: 
https://github.com/NatTuck/microblog
https://github.com/NatTuck/memory

Design Choices for Task Tracker

Task Tracker is a web application which makes use of an owner based access control authorization in the working of the application. The functionalities of the application can be accessed and modified upon registering and then logging into the application. The following are the design choices that were applied for the development of the application.

Application Design:
•	Anyone can register for an account in Task Tracker using Name and Email.
•	Once registered, the user can login to his account using the email address. Passwords are not required for logging in.
•	Upon logging in, the user can start creating tasks by clicking on the ‘Create Task’ button.
•	There are three categories of tasks that the user gets to explore in Task Tracker. They are: My Tasks, Open Tasks and Closed Tasks.
•	My Tasks displays the tasks that the user has been assigned to and is currently working on /or completed. A user can edit the task by clicking on ‘Edit’ button and view the task details by clicking on ‘Show’ button.
•	Open Tasks are the tasks that are open for working, they are created by the users of the application. These open tasks are not marked complete by any user (hence stays in the open tasks category). They can be edited by a user only upon either of the two conditions.
    (a)	The task has not been assigned to any other user so far.
    (b)	The task is already assigned to the user.
•	If a user wishes to work on any open task that has not been assigned to anyone, he can click on ‘Edit’ and assign himself as the assignee to that particular task.
•	If a user wishes to assign another user to an open task that he has been assigned to, he can click on ‘Edit’ and assign another user for the task.
•	Closed Tasks are the completed tasks. They can be edited only by the assigned user once completed. A user can view the details of the completed tasks by clicking on ‘Show’ button.
•	User can enter the time he has worked upon as minutes (increment of 15) in each of the tasks, before marking it as complete.


Now you can visit [`tasktracker`](http://tasktracker.curiousmind.tech/) from your browser.


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`
