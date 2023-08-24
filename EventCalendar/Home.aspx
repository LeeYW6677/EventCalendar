<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="EventCalendar.Home" ViewStateMode="Enabled" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event Calendar</title>
    <link href="style.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous"/>
</head>
<body>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    <form id="form1" runat="server">
        <div class="calendar mx-auto w-75 border border-dark mt-3 h-auto"> 
            <div class="row mx-0">
                <div class="calendarDate w-50 text-center">
                    <div class="row my-2">
                        <asp:LinkButton ID="prevYear" runat="server" OnClick="prevYear_Click" CssClass="w-25 mx-auto text-dark">
                            <i class="fa-solid fa-chevron-left"></i>
                        </asp:LinkButton>
                        <asp:TextBox ID="txtYear" runat="server" CssClass="w-50 border border-0 text-center" ReadOnly="true"></asp:TextBox>
                        <asp:LinkButton ID="nextYear" runat="server" OnClick="nextYear_Click" CssClass="w-25 mx-auto text-dark">
                            <i class="fa-solid fa-chevron-right"></i>
                        </asp:LinkButton>
                    </div>
                    <div class="row my-2">
                        <asp:LinkButton ID="prevMonth" runat="server" OnClick="prevMonth_Click" CssClass="w-25 mx-auto text-dark">
                            <i class="fa-solid fa-chevron-left"></i>
                        </asp:LinkButton>
                        <asp:TextBox ID="txtMonth" runat="server" CssClass="w-50 border border-0 text-center" ReadOnly="true"></asp:TextBox>
                        <asp:LinkButton ID="nextMonth" runat="server" OnClick="nextMonth_Click" CssClass="w-25 mx-auto text-dark">
                            <i class="fa-solid fa-chevron-right"></i>
                        </asp:LinkButton>
                    </div>
                    <asp:Table ID="dateTable" runat="server" CssClass="w-100 bg-transparent table">
                        <asp:TableRow CssClass="w-100">
                            <asp:TableCell width="14.28%">Sun</asp:TableCell>
                            <asp:TableCell width="14.28%">Mon</asp:TableCell>
                            <asp:TableCell width="14.28%">Tue</asp:TableCell>
                            <asp:TableCell width="14.28%">Wed</asp:TableCell>
                            <asp:TableCell width="14.28%">Thu</asp:TableCell>
                            <asp:TableCell width="14.28%">Fri</asp:TableCell>
                            <asp:TableCell width="14.28%">Sat</asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>

                    <asp:Button ID="addBtn" runat="server" CausesValidation="false" Text="Add Event" class="btn text-light mb-3 highlight" OnClick="addEventButton_Click">
                    </asp:Button>
                </div>
                <div class="activityList w-50 p-0 border border-dark">
                    <h4 class="text-light text-center w-100 my-0 py-2" style="background-color:teal;" id="selectedDate" runat="server"></h4>
                    <asp:Repeater ID="eventRepeater" runat="server">
                            <ItemTemplate>
                                <div class="event mt-3" style="border-bottom: 1px solid gray;">
                                    <div class="row">
                                        <div class="d-flex align-items-center justify-content-end" style="width:10%;">
                                            <div style="height:15px;width:15px;background-color:<%# Eval("Color") %>" class="rounded border border-1"></div>
                                        </div>
                                        <div style="width:65%;">
                                            <h5 runat="server"><%# Eval("EventName") %></h5>
                                        </div>
                                        <div class="w-25">
                                            <asp:LinkButton ID="btnEdit" runat="server" CssClass=" mx-auto text-decoration-none text-dark" CommandArgument='<%# Eval("EventId") %>' OnCommand="btnEdit_Command" CausesValidation="false">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CssClass="mx-3 text-decoration-none text-dark" CommandArgument='<%# Eval("EventId") %>' OnCommand="btnDelete_Command" CausesValidation="false">
                                                <i class="fa-solid fa-trash"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="text-center" style="width:10%;"></div>
                                        <div class="w-auto" style="margin-top: -5px;">
                                            <p> <%# Eval("StartDateTime", "{0:dd/MM/yy}") %> - <%# Eval("EndDateTime", "{0:dd/MM/yy}") %></p>
                                            <p style="margin-top: -15px;"> <%# Eval("StartDateTime", "{0:h:mm tt}") %> - <%# Eval("EndDateTime", "{0:h:mm tt}") %></p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="text-center" style="width:10%;">

                                        </div>
                                        <div class="w-auto" style="margin-top: -15px;">
                                            <p> <%# Eval("Description") %></p>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                    </asp:Repeater>
                    <p id="empty" runat="server" class="text-center">There is no event planned for this month!</p>
                </div>
            </div>
        </div>

       <!-- Add Modal -->
        <div class="modal fade" id="addModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h4 class="modal-title">Event Details</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="form-group">
                            <label for="txtEventName">Event Name:</label>
                            <asp:TextBox ID="txtEventName" runat="server" CssClass="form-control" placeholder="Event Name" />
                            <asp:RequiredFieldValidator ID="rfvEventName" runat="server" ErrorMessage="Please enter event name." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtEventName" SetFocusOnError="true" ValidationGroup="Add"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtStartDate">Start Date and Time:</label>
                            <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                            <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ErrorMessage="Please enter event start date and time." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtStartDate" SetFocusOnError="true" ValidationGroup="Add" ></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtEndDate">End Date and Time:</label>
                            <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                            <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ErrorMessage="Please enter event end date and time." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtEndDate" SetFocusOnError="true" ValidationGroup="Add"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtEventDescription">Event Description:</label>
                            <asp:TextBox ID="txtEventDescription" runat="server" CssClass="form-control" placeholder="Event Description" />
                            <asp:RequiredFieldValidator ID="rfvEventDescription" runat="server" ErrorMessage="Please enter event description." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtEventDescription" SetFocusOnError="true" ValidationGroup="Add"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtColor">Color Tag:</label>
                            <asp:TextBox ID="txtColor" runat="server" CssClass="form-control" TextMode="Color" />
                        </div>
                    </div>

                    <div class="modal-footer">
                        <asp:Button ID="btnSave" runat="server" Text="Save Event" CssClass="btn btn-primary" OnClick="btnSaveEvent_Click" ValidationGroup="Add"/>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>  

       <!-- edit Modal -->
        <div class="modal fade" id="editModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h4 class="modal-title">Event Details</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="form-group">
                            <asp:TextBox ID="txtEventID" runat="server" CssClass="form-control" type="hidden" />
                        </div>

                        <div class="form-group">
                            <label for="txtEventName1">Event Name:</label>
                            <asp:TextBox ID="txtEventName1" runat="server" CssClass="form-control" placeholder="Event Name" />
                            <asp:RequiredFieldValidator ID="rfvEventName1" runat="server" ErrorMessage="Please enter event name." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtEventName1" SetFocusOnError="true" ValidationGroup="Edit"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtStartDate1">Start Date and Time:</label>
                            <asp:TextBox ID="txtStartDate1" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                            <asp:RequiredFieldValidator ID="rfvStartDate1" runat="server" ErrorMessage="Please enter event start date and time." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtStartDate1" SetFocusOnError="true" ValidationGroup="Edit"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtEndDate1">End Date and Time:</label>
                            <asp:TextBox ID="txtEndDate1" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                            <asp:RequiredFieldValidator ID="rfvEndDate1" runat="server" ErrorMessage="Please enter event end date and time." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtEndDate1" SetFocusOnError="true" ValidationGroup="Edit"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtEventDescription1">Event Description:</label>
                            <asp:TextBox ID="txtEventDescription1" runat="server" CssClass="form-control" placeholder="Event Description" />
                            <asp:RequiredFieldValidator ID="rfvEventDescription1" runat="server" ErrorMessage="Please enter event description." CssClass="text-danger" Display="Dynamic" ControlToValidate="txtEventDescription1" SetFocusOnError="true" ValidationGroup="Edit"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="txtColor1">Event Color:</label>
                            <asp:TextBox ID="txtColor1" runat="server" CssClass="form-control" TextMode="Color" />
                        </div>
                    </div>

                    <div class="modal-footer">
                        <asp:Button ID="btnEditEvent" runat="server" Text="Edit Event" CssClass="btn btn-primary" OnClick="btnEditEvent_Click" ValidationGroup="Edit"/>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>

                </div>
            </div>
        </div>

         <!-- Delete Modal -->
        <div class="modal fade" id="deleteModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h4 class="modal-title">Event Details</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <asp:TextBox ID="txtEventID1" runat="server" CssClass="form-control" type="hidden"/><br />
                        <p>Are you sure you want to delete this event?</p>
                    </div>

                    <div class="modal-footer">
                        <asp:Button ID="btnDeleteEvent" runat="server" Text="Delete Event" CssClass="btn btn-primary" OnClick="btnDeleteEvent_Click" CausesValidation="false"/>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>

                </div>
            </div>
        </div>
    </form>

</body>
</html>
