// Loader
var loader = document.getElementById("loader");
loader.style.visibility = "visible";
setTimeout(function () {
    loader.style.visibility = "hidden";
}, 1000);

// Menu toggle
if (document.querySelector(".menu-btn")) {
    jQuery('.menu-btn').on('click', function (event) {
        jQuery('.secondary-menu').toggleClass('open-menu');
        jQuery('.menu-btn').toggleClass('open-menu');
        jQuery('body').toggleClass('open-menu');
        jQuery('header').toggleClass('open');
    });
}

// Custom Input File
if (document.querySelector(".input_btn")) {
    document.getElementById("input_btn")
        .addEventListener('click', function () {
            document.getElementById("input_file").click();
        }, false);
}


// Change the selector if needed
if (document.querySelector(".table")) {
    var $table = $('table.scroll'),
        $bodyCells = $table.find('tbody tr:first').children(),
        colWidth;

    // Adjust the width of thead cells when window resizes
    $(window).resize(function () {
        // Get the tbody columns width array
        colWidth = $bodyCells.map(function () {
            return $(this).width();
        }).get();

        // Set the width of thead columns
        $table.find('thead tr').children().each(function (i, v) {
            $(v).width(colWidth[i]);
        });
    }).resize(); // Trigger resize handler
}

// Sumo Select
if (document.querySelector(".sumoSelect")) {
    $('.sumoSelect').SumoSelect();
}

if (document.querySelector(".search_test")) {
    //$('#search_to').SumoSelect({
    //    search: true, searchText: 'Enter here.'
    //});


    $('#drpRemarks').SumoSelect({
        search: true, searchText: 'Enter here.'
    });

    $('#search_Kitchen').SumoSelect({
        search: true, searchText: 'Enter here.'
    });


    $('#search_TrackMsg').SumoSelect({
        search: true, searchText: 'Enter here.'
    });


    $('#drpCompletedRemarks').SumoSelect({
        search: true, searchText: 'Enter here.'
    });


    $('.search_CatChargeGroup').SumoSelect({
        search: true, searchText: 'Enter here.'
    });


    $('#drpCancelRemarks').SumoSelect({
        search: true, searchText: 'Enter here.'
    });

    $('#drpMsgTrack').SumoSelect({
        search: true, searchText: 'Enter here.'
    });

    /* $('#search_from').SumoSelect({
         search: true, searchText: 'Enter here.'
     });
 
     $('#search_Halt1').SumoSelect({
         search: true, searchText: 'Enter here.'
     });
 
     $('#search_Halt2').SumoSelect({
         search: true, searchText: 'Enter here.'
     });
 
     $('#search_to').SumoSelect({
         search: true, searchText: 'Enter here.'
     }); */


    $('#search_floorName').SumoSelect({
        search: true, searchText: 'Enter here.'/*,
        searchFn: function (haystack, needle, el) {
            alert(haystack.toLowerCase().indexOf(needle.toLowerCase()) < 0);
        }*/
    });

    $('#search_KitchenZone').SumoSelect({
        search: true, searchText: 'Enter here.'/*,
        searchFn: function (haystack, needle, el) {
            alert(haystack.toLowerCase().indexOf(needle.toLowerCase()) < 0);
        }*/
    });
    $('#search_RoleName').SumoSelect({
        search: true, searchText: 'Enter here.'/*,
        searchFn: function (haystack, needle, el) {
            alert(haystack.toLowerCase().indexOf(needle.toLowerCase()) < 0);
        }*/
    });


    $('#search_PorterMT').SumoSelect({
        search: true, searchText: 'Enter here.'/*,
        searchFn: function (haystack, needle, el) {
            alert(haystack.toLowerCase().indexOf(needle.toLowerCase()) < 0);
        }*/
    });

    $('#search_Remarks').SumoSelect({
        search: true, searchText: 'Enter here.',
        okCancelInMulti: true
        /*selectAll: true*/
    });

    $('#search_CompleteRemarks').SumoSelect({
        search: true, searchText: 'Enter here.',
        okCancelInMulti: true
    });


    $('#ChartType').SumoSelect({
        search: true, searchText: 'Enter here.'
        //selectAll: true
    });


    $('#selRequestStatus').SumoSelect({
        search: true, searchText: 'Enter here.'
        //selectAll: true
    });

    $('#drpPorterRemarks').SumoSelect({
        search: true, searchText: 'Enter here.'
        //okCancelInMulti: false,
        // selectAll: true
    });

    $('#search_PatientRemarks').SumoSelect({
        search: true, searchText: 'Enter here.'
        //okCancelInMulti: false,
       // selectAll: true
    });


    $('#search_PatientRemarks').on('sumo:opening', function () {
        $('.select-all').css('height', '35px').css('text-align', 'center').css('margin-left', '-40px').css('font-weight', '14px !important');

        $('.select-all span').css('display', 'inline-block !important');

    });
    $('#search_TaskFields').SumoSelect({
        search: true, searchText: 'Enter here.'
        //okCancelInMulti: true,
        //selectAll: true
    });
    $('#search_TaskFields').on('sumo:opening', function () {
        $('.select-all').css('height', '35px').css('text-align', 'center').css('margin-left', '-40px').css('font-weight', '14px !important');

        $('.select-all span').css('display', 'inline-block !important');

    });

    $('#search_CancelRemarks').SumoSelect({
        search: true, searchText: 'Enter here.',
        okCancelInMulti: true
        //selectAll: true
    });

    $('#searchCR_CancelRemarks').SumoSelect({
        search: true, searchText: 'Enter here.',
        okCancelInMulti: true
        //selectAll: true
    });

    $('#selLogFilter').SumoSelect({
        search: true, searchText: 'Enter here.'
        //okCancelInMulti: true,
        //selectAll: true
    });
    $('#selRequestStatus').SumoSelect({
        search: true, searchText: 'Enter here.'
        //okCancelInMulti: true,
        //selectAll: true
    });


    $('#selectPorter').SumoSelect({
        search: true, searchText: 'Enter here.'/*,
        searchFn: function (haystack, needle, el) {
            alert(haystack.toLowerCase().indexOf(needle.toLowerCase()) < 0);
        }*/
    });


}

// Custom Calendar
if (document.querySelector(".custom-calendar-wrap")) {
    const daysTag = document.querySelector(".days"),
        currentDate = document.querySelector(".current-date"),
        prevNextIcon = document.querySelectorAll(".icons span");
    // getting new date, current year and month
    let date = new Date(),
        currYear = date.getFullYear(),
        currMonth = date.getMonth();
    // storing full name of all months in array
    const months = ["January", "February", "March", "April", "May", "June", "July",
        "August", "September", "October", "November", "December"];
    const renderCalendar = () => {
        let firstDayofMonth = new Date(currYear, currMonth, 1).getDay(), // getting first day of month
            lastDateofMonth = new Date(currYear, currMonth + 1, 0).getDate(), // getting last date of month
            lastDayofMonth = new Date(currYear, currMonth, lastDateofMonth).getDay(), // getting last day of month
            lastDateofLastMonth = new Date(currYear, currMonth, 0).getDate(); // getting last date of previous month
        let liTag = "";
        for (let i = firstDayofMonth; i > 0; i--) { // creating li of previous month last days
            liTag += `<li class="inactive">${lastDateofLastMonth - i + 1}</li>`;
        }
        for (let i = 1; i <= lastDateofMonth; i++) { // creating li of all days of current month
            // adding active class to li if the current day, month, and year matched
            let isToday = i === date.getDate() && currMonth === new Date().getMonth()
                && currYear === new Date().getFullYear() ? "active" : "";
            liTag += `<li class="${isToday}">${i}</li>`;
        }
        for (let i = lastDayofMonth; i < 6; i++) { // creating li of next month first days
            liTag += `<li class="inactive">${i - lastDayofMonth + 1}</li>`
        }
        //    currentDate.innerText = `${months[currMonth]} ${currYear}`; // passing current mon and yr as currentDate text
        //daysTag.innerHTML = liTag;
    }
    renderCalendar();
    prevNextIcon.forEach(icon => { // getting prev and next icons
        icon.addEventListener("click", () => { // adding click event on both icons
            // if clicked icon is previous icon then decrement current month by 1 else increment it by 1
            currMonth = icon.id === "prev" ? currMonth - 1 : currMonth + 1;
            if (currMonth < 0 || currMonth > 11) { // if current month is less than 0 or greater than 11
                // creating a new date of current year & month and pass it as date value
                date = new Date(currYear, currMonth, new Date().getDate());
                currYear = date.getFullYear(); // updating current year with new date year
                currMonth = date.getMonth(); // updating current month with new date month
            } else {
                date = new Date(); // pass the current date as date value
            }
            renderCalendar(); // calling renderCalendar function
        });
    });
}
// Custom Calendar end

// Custom Calendar page
if (document.querySelector(".custom-calendar-wrap-page")) {
    const daysTag = document.querySelector(".days-page"),
        currentDate = document.querySelector(".current-date-page"),
        prevNextIcon = document.querySelectorAll(".icons-page span");
    // getting new date, current year and month
    let date = new Date(),
        currYear = date.getFullYear(),
        currMonth = date.getMonth();
    // storing full name of all months in array
    const months = ["January", "February", "March", "April", "May", "June", "July",
        "August", "September", "October", "November", "December"];
    const renderCalendar = () => {
        let firstDayofMonth = new Date(currYear, currMonth, 1).getDay(), // getting first day of month
            lastDateofMonth = new Date(currYear, currMonth + 1, 0).getDate(), // getting last date of month
            lastDayofMonth = new Date(currYear, currMonth, lastDateofMonth).getDay(), // getting last day of month
            lastDateofLastMonth = new Date(currYear, currMonth, 0).getDate(); // getting last date of previous month
        let liTag = "";
        for (let i = firstDayofMonth; i > 0; i--) { // creating li of previous month last days
            liTag += `<li class="inactive">${lastDateofLastMonth - i + 1}</li>`;
        }
        for (let i = 1; i <= lastDateofMonth; i++) { // creating li of all days of current month
            // adding active class to li if the current day, month, and year matched
            let isToday = i === date.getDate() && currMonth === new Date().getMonth()
                && currYear === new Date().getFullYear() ? "active" : "";
            liTag += `<li class="${isToday}">${i}</li>`;
        }
        for (let i = lastDayofMonth; i < 6; i++) { // creating li of next month first days
            liTag += `<li class="inactive">${i - lastDayofMonth + 1}</li>`
        }
        currentDate.innerText = `${months[currMonth]} ${currYear}`; // passing current mon and yr as currentDate text
        daysTag.innerHTML = liTag;
    }
    renderCalendar();
    prevNextIcon.forEach(icon => { // getting prev and next icons
        icon.addEventListener("click", () => { // adding click event on both icons
            // if clicked icon is previous icon then decrement current month by 1 else increment it by 1
            currMonth = icon.id === "prevPage" ? currMonth - 1 : currMonth + 1;
            if (currMonth < 0 || currMonth > 11) { // if current month is less than 0 or greater than 11
                // creating a new date of current year & month and pass it as date value
                date = new Date(currYear, currMonth, new Date().getDate());
                currYear = date.getFullYear(); // updating current year with new date year
                currMonth = date.getMonth(); // updating current month with new date month
            } else {
                date = new Date(); // pass the current date as date value
            }
            renderCalendar(); // calling renderCalendar function
        });
    });
}
// Custom Calendar page end


if (document.querySelector(".category-master-item")) {
    jQuery('.edit-category').click(function () {
        jQuerythis = jQuery(this);
        jQuerythis.parents('.category-master-item').toggleClass('active');
        jQuerythis.parents('.category-master-item').find('.card-bottom').slideToggle();
    });
    jQuery('.cancel-edit').click(function () {
        jQuerythis = jQuery(this);
        jQuerythis.parents('.category-master-item').toggleClass('active');
        jQuerythis.parents('.category-master-item').find('.card-bottom').slideToggle();
    });
}

/* Chart */
if (document.querySelector(".dashboard-chart-large")) {
    const ctx = document.getElementById('dashboardChart');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['FALL', 'ADII', 'Lorem', 'DTC', 'DMC', 'Lorem', 'EMID', 'University', 'EPC', 'Lorem', 'Lorem', 'Lorem'],
            datasets: [{
                label: ['In Progress (IP)'],
                data: [0.6, 0.7, 0.5, 0.6, 0.5, 0.4, 1.6, 0.6, 0.8, 0.4, 0.3, 0.4],
                borderColor: '#FFC727',
                backgroundColor: '#FFC727',
            }, {
                label: ['Completed (COM)'],
                data: [0.8, 0.8, 0.7, 0.4, 0.5, 0.6, 1.7, 0.6, 0.8, 0.5, 0.3, 0.3],
                borderColor: '#0CBC8B',
                backgroundColor: '#0CBC8B',
            }, {
                label: ['Not Delivered (ND)'],
                data: [0.9, 0.9, 0.9, 0.5, 0.6, 0.8, 1.9, 0.8, 0.5, 0.7, 0.5, 0.06],
                borderColor: '#E5F1FF',
                backgroundColor: '#E5F1FF',
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                },
                y: {
                    ticks: {
                        // Include a dollar sign in the ticks
                        callback: function (value, index, ticks) {
                            return value + 'k';
                        }
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartOne');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.5, 1, 1.5, 2.6, 1.2],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                },
                y: {
                    ticks: {
                        // Include a dollar sign in the ticks
                        callback: function (value, index, ticks) {
                            return value + 'k';
                        }
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartTwo');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartThree');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartFour');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartFive');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartSix');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartSeven');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

if (document.querySelector(".dashboard-chart-small")) {
    const ctx = document.getElementById('dashboardChartEight');
    // This chart would show a line only for the third dataset
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['UA', 'ND', 'NS', 'IP', 'COM'],
            datasets: [{
                barPercentage: 0.5,
                barThickness: 2,
                maxBarThickness: 8,
                minBarLength: 3,
                data: [0.2, 1.7, 0.7, 1.8, 1],
                backgroundColor: [
                    '#39291C',
                    '#4200FF',
                    '#F25252',
                    '#FFC727',
                    '#0CBC8B',
                    '#0CBC8B'
                ],
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        drawOnChartArea: false
                    }
                }
            }
        }
    });
}

function redirectFloorwiseTrac() {

    var wind = window.open('../Track/FloorWiseTrack.aspx', '_blank', 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1500,height=750');

}


// Tooltip
var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
})

// Select Language
// jQuery('.select-language').on('click',function(){
//     jQuery(this).text(jQuery(this).text() == "English" ? "Thai": "English");
//     jQuery(this).toggleClass('btn-toggle')
// })