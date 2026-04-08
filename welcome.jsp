<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>

<%
    String username = request.getParameter("username");
    
    if(username != null){
        session.setAttribute("user", username);
    }
    
    String user = (String) session.getAttribute("user");
    
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Handle adding new task
    String newTask = request.getParameter("newTask");
    if(newTask != null && !newTask.trim().isEmpty()){
        List<String> tasks = (List<String>) session.getAttribute("userTasks");
        if(tasks == null){
            tasks = new ArrayList<String>();
        }
        tasks.add(newTask.trim());
        session.setAttribute("userTasks", tasks);
    }
    
    // Handle deleting task
    String deleteIndex = request.getParameter("deleteIndex");
    if(deleteIndex != null){
        try{
            int index = Integer.parseInt(deleteIndex);
            List<String> tasks = (List<String>) session.getAttribute("userTasks");
            if(tasks != null && index >= 0 && index < tasks.size()){
                tasks.remove(index);
            }
        } catch(Exception e) {}
    }
    
    List<String> tasks = (List<String>) session.getAttribute("userTasks");
    if(tasks == null){
        tasks = new ArrayList<String>();
    }
    
    // Calculate task stats
    int totalTasks = tasks.size();
    Date currentDate = new Date();
    String dayOfWeek = new java.text.SimpleDateFormat("EEEE").format(currentDate);
%>

<html>
<head>
<title>Task Manager - Dashboard</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px;
    }
    
    .navbar {
        background: white;
        padding: 15px 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    
    .navbar h1 {
        color: #667eea;
        font-size: 22px;
    }
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    
    .user-info span {
        color: #666;
    }
    
    .logout-btn {
        background: #e74c3c;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 600;
        transition: background 0.3s;
    }
    
    .logout-btn:hover {
        background: #c0392b;
    }
    
    .container {
        max-width: 800px;
        margin: 0 auto;
    }
    
    .stats {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
        margin-bottom: 20px;
    }
    
    .stat-card {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    
    .stat-card h3 {
        color: #666;
        font-size: 14px;
        text-transform: uppercase;
        margin-bottom: 10px;
    }
    
    .stat-value {
        font-size: 32px;
        font-weight: bold;
        color: #667eea;
    }
    
    .main-card {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 25px;
    }
    
    .add-task-form {
        margin-bottom: 25px;
        display: flex;
        gap: 10px;
    }
    
    .add-task-form input {
        flex: 1;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 14px;
        transition: border-color 0.3s;
    }
    
    .add-task-form input:focus {
        outline: none;
        border-color: #667eea;
    }
    
    .add-task-form button {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 12px 25px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 600;
        transition: transform 0.2s;
    }
    
    .add-task-form button:hover {
        transform: translateY(-2px);
    }
    
    .tasks-list {
        border-top: 2px solid #e0e0e0;
        padding-top: 20px;
    }
    
    .tasks-list h3 {
        color: #333;
        margin-bottom: 15px;
        font-size: 18px;
    }
    
    .task-item {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: all 0.3s;
    }
    
    .task-item:hover {
        background: #f0f0f0;
        transform: translateX(5px);
    }
    
    .task-text {
        color: #333;
        font-size: 15px;
    }
    
    .delete-btn {
        background: #e74c3c;
        color: white;
        border: none;
        padding: 6px 12px;
        border-radius: 3px;
        cursor: pointer;
        font-size: 12px;
        font-weight: 600;
        transition: background 0.3s;
    }
    
    .delete-btn:hover {
        background: #c0392b;
    }
    
    .empty-message {
        text-align: center;
        color: #999;
        padding: 30px;
        font-size: 16px;
    }
</style>
</head>

<body>
    <div class="navbar">
        <h1> Task Manager</h1>
        <div class="user-info">
            <span>Welcome, <strong><%= user %></strong></span>
            <form action="logout.jsp" style="margin: 0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
    
    <div class="container">
        <div class="stats">
            <div class="stat-card">
                <h3>Total Tasks</h3>
                <div class="stat-value"><%= totalTasks %></div>
            </div>
            <div class="stat-card">
                <h3>Today</h3>
                <div class="stat-value"><%= dayOfWeek.substring(0, 3) %></div>
            </div>
        </div>
        
        <div class="main-card">
            <form class="add-task-form" method="post">
                <input type="text" name="newTask" placeholder="Add a new task..." required>
                <button type="submit">Add Task</button>
            </form>
            
            <div class="tasks-list">
                <h3>Your Tasks</h3>
                <% if(totalTasks == 0) { %>
                    <div class="empty-message">No tasks yet. Add one to get started!</div>
                <% } else { %>
                    <% for(int i = 0; i < tasks.size(); i++) { %>
                        <div class="task-item">
                            <span class="task-text"><%= i + 1 %>. <%= tasks.get(i) %></span>
                            <form method="post" style="margin: 0;">
                                <input type="hidden" name="deleteIndex" value="<%= i %>">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
