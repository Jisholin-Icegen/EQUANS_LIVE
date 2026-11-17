<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddTask.aspx.cs" Inherits="AddTask_AddTask" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>Add Task | TRACZO</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" href="../favicon.png" />
    <!-- Favicon -->
    <link rel="icon" href="favicon.png" />
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="../css/bootstrap1.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/sumoselect1.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/style1.css" />
</head>

<body class="">
    <div class="lang-menu">
        <select id="dropdown">
            <option>Select</option>
            <option class="porter" value="porter">Porter</option>
            <option class="cleaning" value="cleaning">Cleaning</option>
        </select>
        <a class="select-language" href="index-thai.html">Thai</a>
    </div>
    <div id="loader" class="loader-wrapper">
        <img src="../images/Traczo.svg" alt="Traczo">
    </div>
    <div class="main-wrapper">
        <div class="main-screen-wrap">
            <div class="main-screen-inner">

                <!-- Left Panel -->
                <div class="screen-left-panel">
                    <div class="screen-left-sticky">
                        <div>
                            <div class="traczo-logo">
                                <a href="index.html">
                                    <img src="../images/Traczo.svg" alt="Traczo">
                                </a>
                            </div>
                            <div class="hospital-img">
                                <img src="../images/hospital.jpg" alt="Hospital">
                            </div>
                            <div class="hospital-title">
                                <h5>Welcome</h5>
                                <h6>Apollo Hospital,</h6>
                                <p>Greames Road</p>
                            </div>
                                <div class="left-panel-menu">
                                    <ul>
                                        <li class="current-menu-item">
                                            <a href="../Index/Index.aspx">
                                                <span>
                                                    <img src="../images/home.png" alt="Home"></span> Home
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Reports/Report.aspx">
                                                <span>
                                                    <img src="../images/clipboard.png" alt="Reports"></span> Reports
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Master/Users.aspx">
                                                <span>
                                                    <img src="../images/porter-master.png" alt="Location Master"></span> User Master
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Master/Locations.aspx">
                                                <span>
                                                    <img src="../images/location.png" alt="Location Master"></span> Location Master
                                            </a>
                                        </li>

                                    </ul>
                                </div>
                        <div>
                            <div class="profile-link">
                                <div class="profile-img">
                                    <img src="../images/profile.jpg" alt="Profile">
                                </div>
                                <div class="profile-designation">
                                    <h6>Account Profile</h6>
                                </div>
                                <a href="login.html" class="stretched-link"></a>
                            </div>
                            <div class="add-task-link">
                                <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addTask"
                                    class="btn btn-primary">
                                    <img src="../images/memo.png" alt="Add Task">
                                    Add task
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /Left Panel -->
                <!-- Right Panel -->
                <div class="screen-right-panel">
                    <div class="py-2"></div>
                    <div class="row">
                        <div class="col-md-12">
                            <!-- Section heading -->
                            <div class="section-head">
                                <div class="section-head-left">
                                    <h5>Add Task</h5>
                                </div>
                                <div class="section-head-right d-flex align-items-center">
                                    <a href="#" data-bs-toggle="modal" data-bs-target="#preBook" class="btn btn-secondary">
                                        <img src="../images/spiral-calendar.png" alt="Pre Book">
                                        Pre Book
                                    </a>
                                </div>
                            </div>
                            <!-- /Section heading -->

                            <div class="card">
                                <div class="add-task-wrap">
                                    <form action="" id="myForm">
                                        <div class="d-flex align-items-center">
                                            <div class="from-title">
                                                <h5>From</h5>
                                            </div>
                                            <div class="task-type">
                                                <span class="left"></span>
                                                <div class="btn btn-primary">Task type</div>
                                                <span class="right"></span>
                                            </div>
                                            <div class="to-title text-end">
                                                <h5>To</h5>
                                            </div>
                                        </div>
                                        <div class="locations">
                                            <div class="from-location-wrap">
                                                <div class="from-location mb-4">
                                                    <div class="sumo-container">
                                                        <select class="select sumoSelect sumo-select">
                                                            <option value="Select location">Select location</option>
                                                            <option value="Location A">Location A</option>
                                                            <option value="Location B">Location B</option>
                                                            <option value="Location C">Location C</option>
                                                            <option value="Location D">Location D</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <hr>
                                                <div class="from-location mb-4">
                                                    <div class="sumo-container">
                                                        <p>Optional</p>
                                                        <select class="select sumoSelect sumo-select">
                                                            <option value="Select location">Select location</option>
                                                            <option value="Location A">Location A</option>
                                                            <option value="Location B">Location B</option>
                                                            <option value="Location C">Location C</option>
                                                            <option value="Location D">Location D</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="task-type-btn" data-bs-toggle="modal" data-bs-target="#stepFormModal">
                                                <div class="icon-wrap">
                                                    <img src="../images/icon-samples.png" alt="Medicines">
                                                </div>
                                                <span class="btn">Medicines</span>
                                            </div>
                                            <div class="to-location-wrap">
                                                <div class="to-location mb-4">
                                                    <div class="sumo-container">
                                                        <select class="select sumoSelect sumo-select">
                                                            <option value="Select location">Select location</option>
                                                            <option value="Location A">Location A</option>
                                                            <option value="Location B">Location B</option>
                                                            <option value="Location C">Location C</option>
                                                            <option value="Location D">Location D</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <hr>
                                                <div class="to-location mb-4">
                                                    <div class="sumo-container">
                                                        <p>Optional</p>
                                                        <select class="select sumoSelect sumo-select">
                                                            <option value="Select location">Select location</option>
                                                            <option value="Location A">Location A</option>
                                                            <option value="Location B">Location B</option>
                                                            <option value="Location C">Location C</option>
                                                            <option value="Location D">Location D</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="py-3"></div>
                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="row">
                                                    <div class="col-sm-3">
                                                        <label for="patient-name" class="mt-2">Patient Name</label>
                                                    </div>
                                                    <div class="col-sm-9">
                                                        <input type="text" id="patient-name" class="form-control" placeholder="Patient Name">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <select name="month" class="sumoSelect other-select">
                                                            <option value="Others">Others</option>
                                                            <option value="Others 1">Others 1</option>
                                                            <option value="Others 2">Others 2</option>
                                                            <option value="Others 3">Others 3</option>
                                                            <option value="Others 4">Others 4</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="py-3"></div>
                                        <div class="row">
                                            <div class="col-sm-2">
                                                <label for="remark" class="mt-2">Remarks</label>
                                            </div>
                                            <div class="col-sm-10">
                                                <textarea class="form-control" placeholder="Remarks" name="" id="" cols="30" rows="4"></textarea>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="pt-3 pb-4"></div>
                                                <div class="d-flex justify-content-end btns">
                                                    <a href="#" class="btn btn-outline btn-tertiary me-3" onclick="clearForm()">Clear</a>
                                                    <a href="#" class="btn btn-outline btn-tertiary me-3" onclick="clearForm()">
                                                        <img src="../images/close-dark.png" alt="">
                                                        Cancel</a>
                                                    <button type="button" class="btn btn-secondary">
                                                        <img src="../images/envelope.png">
                                                        Submit</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /Right Panel -->
            </div>
        </div>
    </div>

    <!-- Step form Modal -->
    <div class="modal" id="stepFormModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Task Type</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                        <img src="../images/close-white.svg">
                    </button>
                </div>
                <div class="modal-body">
                    <div class="icon-section">
                        <ul>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-bed.png" alt="Bed">
                                <p>Bed</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-documents.png" alt="Documents">
                                <p>Documents</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-pharmacy.png" alt="Pharmacy">
                                <p>Pharmacy</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-cylinder.png" alt="Cylinder">
                                <p>Cylinder</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-samples.png" alt="Samples">
                                <p>Samples</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-stretcher.png" alt="Stretcher">
                                <p>Stretcher</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-wheelchair.png" alt="Wheel-Chair">
                                <p>Wheel-Chair</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-xray.png" alt="X-ray">
                                <p>X Ray</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-porter.png" alt="Porter">
                                <p>Porter</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-cssd.png" alt="CSSD">
                                <p>CSSD</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-ortho-wheelchair.png"
                                    alt="Ortho Wheelchair">
                                <p>Ortho Wheelchair</p>
                            </li>
                            <li>
                                <input type="checkbox">
                                <span>
                                    <img src="../images/check.png"></span>
                                <img src="../images/icon-trolley.png" alt="Trolley">
                                <p>Trolley</p>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" aria-label="Close">Close</button>
                    <button type="button" id="submitButton" class="btn btn-success">Submit</button>
                </div>
            </div>
        </div>
    </div>
    <!-- /Step form Modal -->
    <!-- Pre Book Calendar -->
    <div class="modal" id="preBook" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Pre Book</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                        <img src="../images/close-white.svg">
                    </button>
                </div>
                <div class="modal-body">
                    <div class="pre-book">
                        <div class="custom-calendar-wrap">
                            <div class="custom-calendar">
                                <header>
                                    <div class="icons">
                                        <span id="prev">
                                            <img src="../images/left.svg"></span>
                                        <p class="current-date"></p>
                                        <span id="next">
                                            <img src="../images/right.svg"></span>
                                    </div>
                                </header>
                                <div class="calendar">
                                    <ul class="weeks">
                                        <li>Sun</li>
                                        <li>Mon</li>
                                        <li>Tue</li>
                                        <li>Wed</li>
                                        <li>Thu</li>
                                        <li>Fri</li>
                                        <li>Sat</li>
                                    </ul>
                                    <ul class="days"></ul>
                                </div>
                            </div>
                            <div class="card my-2">
                                <div class="col-md-12 pre-book-hide">
                                    <div class="mb-3">
                                        <label for="task-time">Time</label>
                                        <input type="time" id="task-time" class="form-control">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /Pre Book Calendar -->
    <!-- Porters Info -->
    <!-- Modal -->
    <div class="modal fade" id="porterInfo" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reportsModalLabel">Porter Info</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                        <img src="../images/close-white.svg">
                    </button>
                </div>
                <div class="modal-body">
                    <div class="table-wrap">
                        <div class="table-responsive">
                            <table class="table scroll table-bordered">
                                <thead>
                                    <tr>
                                        <th scope="col">Porter Name</th>
                                        <th scope="col">Login Time</th>
                                        <th scope="col">Status</th>
                                        <th scope="col">No. of Calls</th>
                                        <th scope="col">Total Hours (HH:MM)</th>
                                        <th scope="col">Work Hours (HH:MM)</th>
                                        <th scope="col">Idle Hours (HH:MM)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Sachin</td>
                                        <td>09:00 AM</td>
                                        <td>Busy</td>
                                        <td>20</td>
                                        <td>04:50</td>
                                        <td>03:40</td>
                                        <td>01:10</td>
                                    </tr>
                                    <tr>
                                        <td>Sachin</td>
                                        <td>09:00 AM</td>
                                        <td>Busy</td>
                                        <td>20</td>
                                        <td>04:50</td>
                                        <td>03:40</td>
                                        <td>01:10</td>
                                    </tr>
                                    <tr>
                                        <td>Sachin</td>
                                        <td>09:00 AM</td>
                                        <td>Busy</td>
                                        <td>20</td>
                                        <td>04:50</td>
                                        <td>03:40</td>
                                        <td>01:10</td>
                                    </tr>
                                    <tr>
                                        <td>Sachin</td>
                                        <td>09:00 AM</td>
                                        <td>Busy</td>
                                        <td>20</td>
                                        <td>04:50</td>
                                        <td>03:40</td>
                                        <td>01:10</td>
                                    </tr>
                                    <tr>
                                        <td>Sachin</td>
                                        <td>09:00 AM</td>
                                        <td>Busy</td>
                                        <td>20</td>
                                        <td>04:50</td>
                                        <td>03:40</td>
                                        <td>01:10</td>
                                    </tr>
                                    <tr>
                                        <td>Sachin</td>
                                        <td>09:00 AM</td>
                                        <td>Busy</td>
                                        <td>20</td>
                                        <td>04:50</td>
                                        <td>03:40</td>
                                        <td>01:10</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reports -->
    <!-- Modal -->
    <div class="modal fade" id="reportsModal" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reportsModalLabel">Generate New Report</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                        <img src="../images/close-white.svg">
                    </button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <label for="select-format">Choose Format</label>
                                    <select name="select-format" id="select-format"
                                        class="form-control selectFormat sumoSelect">
                                        <option selected>Select Format</option>
                                        <option value="PDF">PDF</option>
                                        <option value="Excel">Excel</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="since-date">Since</label>
                                    <input type="date" id="since-date" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="to-date">To</label>
                                    <input type="date" id="to-date" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="d-flex justify-content-end">
                                    <button type="button" class="btn btn-outline me-3" data-bs-dismiss="modal">
                                        <img src="../images/multiply.svg">
                                        Cancel
                                    </button>
                                    <input type="submit" value="Generate" class="btn btn-secondary">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- /Reports -->
    <!-- JS CSS -->
    <script src="../js/jquery-3.6.4.min.js"></script>
    <script src="../js/bootstrap1.bundle.min.js"></script>
    <script src="../js/jquery1.sumoselect.min.js"></script>
    <script src="../js/style1.js"></script>
</body>
</html>
