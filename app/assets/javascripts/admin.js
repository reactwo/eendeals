//= require admin/jquery.min
//= require admin/moment
//= require admin/Chart.min
//= require admin/select2.full.min
//= require admin/jquery.barrating.min
//= require admin/ckeditor
//= require admin/validator.min
//= require admin/daterangepicker
//= require admin/ion.rangeSlider.min
//= require admin/dropzone
//= require admin/mindmup-editabletable
//= require admin/jquery.dataTables.min
//= require admin/dataTables.bootstrap.min
//= require admin/dataTables.buttons.min
//= require yadcf/jquery.dataTables.yadcf
//= require admin/fullcalendar.min
//= require admin/perfect-scrollbar.jquery.min
//= require admin/tether.min
//= require admin/util
//= require admin/alert
//= require admin/button
//= require admin/carousel
//= require admin/collapse
//= require admin/dropdown
//= require admin/modal
//= require admin/tab
//= require admin/tooltip
//= require admin/popover
//= require admin/main
//= require lightbox2
//= require rails-ujs

if($('#users-table').length) {
    var users_datatable = $('#users-table').DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $('#users-table').data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": "mobile"},
            {"data": "refer_id"},
            {"data": function(row) {
                    return "<a href='/admin/users/" + row.direct_id + "'>" + row.direct + "</a>";
                }},
            {"data": function(row) {
                    return "<a href='/admin/users/" + row.sponsor_id + "'>" + row.sponsor + "</a>";
                }},
            {"data": "doj"},
            {"data": "wallet"},
            {"data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-success' href='/admin/users/" + row.id + "'>Show</a>";
                }}
        ]
    });

    yadcf.init(users_datatable, [
        { column_number: 0, filter_type: 'text' },
        { column_number: 1, filter_type: 'text' },
        { column_number: 2, filter_type: 'text' },
        { column_number: 3, filter_type: 'text' }
    ]);
}

if($('#quiz-questions-table').length) {
    $('#quiz-questions-table').DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $('#quiz-questions-table').data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "question"},
            {"data": "date"},
            {"data": "created_at"},
            {"data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-info' href='/admin/quiz-questions/" + row.id + "/edit'>Edit</a>";
                }}
        ]
    });
}

if($('#quiz-attempts-table')) {
    $('#quiz-attempts-table').DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $('#quiz-attempts-table').data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": function(row) {
                    return "<a href='/admin/users/" + row.user_id + "'>" + row.name + "</a>";
                }},
            {"data": "status"},
            {"data": "points"},
            {"data": "date"},
            {"data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-info' href='/admin/quiz-attempts/" + row.id + "'>Show</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/quiz-attempts/" + row.id + "'>Delete</a>";
                }}
        ]
    });
}

if($('#user-levels-table')) {
    $('#user-levels-table').DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $('#user-levels-table').data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": function(row) {
                    return "<a href='/admin/users/" + row.user_id + "'>" + row.name + "</a>";
                }},
            {"data": "mobile"}
        ]
    });
}

var $offers_table = $('#offers-table');
if($offers_table) {
    $offers_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $offers_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": function(row) {
                    return "<a href='" + row.link + "' target='_blank'>Click Here</a>"
                }},
            {"data": "active"},
            {"data": "created_at"},
            { "data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-info' href='/admin/offers/" + row.id + "/edit'>Edit</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/offers/" + row.id + "'>Delete</a>" +
                        "<a class='mr-2 mb-2 btn btn-success' style='color: white'>Progress</a>";
                } }
        ]
    });
}

var $deals_table = $('#deals-table');
if($deals_table) {
    $deals_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $deals_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": function(row) {
                    return "<a href='" + row.link + "' target='_blank'>Click Here</a>"
                }},
            {"data": function(row) {
                    return row.cap + '/' + row.downloaded
                }},
            {"data": "active"},
            {"data": "created_at"},
            { "data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-info' href='/admin/deals/" + row.id + "/edit'>Edit</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/deals/" + row.id + "'>Delete</a>" +
                        "<a class='mr-2 mb-2 btn btn-info' href='/admin/deals/" + row.id + "'>Show</a>";
                } }
        ]
    });
}

var $products_table = $('#products-table');
if($products_table) {
    $products_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $products_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": "price"},
            {"data": "created_at"},
            {"data": function(row) {
                    return "<a href='" + row.link + "' target='_blank'>Click Here</a>"
                }},
            { "data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-primary' href='/admin/products/" + row.id + "'>Show</a>" +
                        "<a class='mr-2 mb-2 btn btn-info' href='/admin/products/" + row.id + "/edit'>Edit</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/products/" + row.id + "'>Delete</a>";
                }}
        ]
    });
}

var $tasks_table = $("#tasks-table");
if($tasks_table) {
    $tasks_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $tasks_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": "active"},
            { "data": function(row) {
                    return row.cap + '/' + row.downloaded
                }},
            { data: 'amount' },
            { data: 'created_at' },
            { "data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-primary' href='/admin/tasks/" + row.id + "'>Show</a>" +
                        "<a class='mr-2 mb-2 btn btn-info' href='/admin/tasks/" + row.id + "/edit'>Edit</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/tasks/" + row.id + "'>Delete</a>";
                }}
        ]
    });
}

var $task_submits_table = $("#task-submits-table");
if($task_submits_table) {
    $task_submits_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $task_submits_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": "user"},
            {"data": "status"},
            { "data": function(row) {
                    return "<a href='" + row.image + "' data-lightbox='image-" + row.id + "'>" +
                        "<img src='" + row.image + "' height='50' width='50' />" +
                        "</a>"
                }},
            {"data": "created_at"},
            { "data": function(row) {
                    var a = "<a class='mr-2 mb-2 btn btn-primary' type='button' href='/admin/task-submits/" + row.id + ".js' data-remote='true'>Open</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/task-submits/" + row.id + "'>Delete</a>" +
                        "<a class='mr-2 mb-2 btn btn-primary' href='/admin/task-submits/" + row.id + "'>Show</a>";
                    if(row.status === 'Unapproved') {
                        a += "<a class='mr-2 mb-2 btn btn-primary' href='/admin/task-submits/" + row.id + "' data-method='POST' data-confirm='Are you sure?'>Approve</a>";
                    } else {
                        a += "<a class='mr-2 mb-2 btn btn-danger' href='/admin/task-submits/" + row.id + "' data-method='PATCH' data-confirm='Are you sure?'>Unapprove</a>";
                    }

                    return a;
                }}
        ]
    });
}

var $deal_uploads_table = $('#deal-uploads-table');
if($deal_uploads_table) {
    $deal_uploads_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $deal_uploads_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            {"data": function(row) {
                    return "<img height='50' width='50' src='" + row.image + "' />"
                }},
            {"data": function(row) {
                    return "<a href='/admin/users/" + row.user_id + "'>" + row.user + "</a>"
                }},
            {"data": function(row) {
                    return "<a href='/admin/deals/" + row.deal_id + "'>" + row.deal + ""
                }},
            { data: 'status' },
            { data: 'created_at' },
            {"data": function(row) {
                    return "<a class='mr-2 mb-2 btn btn-primary' type='button' href='/admin/deal-uploads/" + row.id + ".js' data-remote='true'>Open</a>" +
                        "<a class='mr-2 mb-2 btn btn-danger' data-confirm='Are you sure?' data-method='delete' href='/admin/deal-uploads/" + row.id + "'>Delete</a>" +
                        "<a class='mr-2 mb-2 btn btn-primary' href='/admin/deal-uploads/" + row.id + "'>Show</a>";
                }}
        ]
    });
}

var $conversions_table = $('#conversions-table');
if($conversions_table) {
    $conversions_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $conversions_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            {"data": "id"},
            { data: 'transaction_id' },
            { data: 'company' },
            {
                data: function(row) {
                    if(row.offer_id) {
                        return "<a href='/admin/offers/" + row.offer_id + "'>" + row.offer_name + "</a>";
                    } else {
                        return '';
                    }
                }
            },
            {
                data: function(row) {
                    if(row.deal_id) {
                        return "<a href='/admin/deals/" + row.deal_id + "'>" + row.deal_name + "</a>";
                    } else {
                        return '';
                    }
                }
            },
            { data: 'status' },
            {
                data: function(row) {
                    return "<a href='/admin/users/" + row.user_id + "'>" + row.user_name + "</a>";
                }
            },
            { data: 'created_at' },
            {
                data: function(row) {
                    if(row.offer_id && row.status === 'Unapproved') {
                        return "<a class='btn btn-primary' style='color: white' href='/admin/conversions/" + row.id + "/approve' data-method='post'>Approve</a>";
                    } else {
                        return '';
                    }
                }
            }
        ]
    });
}

var $transactions_table = $('#transactions-table');
if($transactions_table) {
    $transactions_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $transactions_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            { data: 'id' },
            { data: 'amount' },
            { data: 'category' },
            { data: 'direction' },
            {
                data: function(row) {
                    if(row.from_user_id) {
                        if(row.from_user_id === row.user_id) {
                            return 'Self';
                        } else {
                            return "<a href='/admin/users/" + row.from_user_id + "'>" + row.from_user_name + "</a>";
                        }
                    } else {
                        return '';
                    }
                }
            },
            { data: 'data' },
            { data: function(row){
                    return "<a href='/admin/users/" + row.user_id + "'>" + row.user_name + "</a>"
                }},
            { data: 'created_at' }
        ]
    });
}

var $redeems_table = $('#redeems-table');
if($redeems_table) {
    $redeems_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $redeems_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            { data: 'id' },
            { data: 'coins' },
            { data: 'kind' },
            { data: function(row) {
                    return "<a href='/admin/users/" + row.user_id +"'>" + row.user_name + "</a>";
                }
            },
            { data: 'status' },
            { data: 'created_at' },
            { data: function(row) {
                console.log(row.status);
                    var approve = "<a class='btn btn-success' style='color: white' href='/admin/redeems/" + row.id + "' data-method='post' data-remote='true'>Approve</a> ";
                    var reject = "<a class='btn btn-danger' style='color: white' href='/admin/redeems/" + row.id + "/decline'>Decline</a> ";
                    var final = approve;
                    if(row.status === 'Approved') {
                        final = reject;
                    } else if(row.status === 'Submitted') {
                        final += reject;
                    }
                    return final + "<a class='btn btn-primary' href='/admin/redeems/" + row.id + "'>Show</a>";
                }
            }
        ]
    });
}

var $quiz_winners_table = $('#quiz-winners-table');
if($quiz_winners_table) {
    $quiz_winners_table.DataTable({
        'processing': true,
        "serverSide": true,
        "ajax": $quiz_winners_table.data('source'),
        "pagingType": "full_numbers",
        "columns": [
            { data: 'id' },
            { data: 'user_id' },
            { data: 'quiz_id' },
            { data: 'points' },
            { data: 'position' },
            { data: 'created_at' }
        ]
    });
}

function showMessage() {
    $('#custom-message').show();
}

function hideMessage() {
    $('#custom-message').hide();
}

$transaction_category = $('#transaction-category-dynamic');
if($transaction_category) {
    $transaction_category.on('change', function() {
        var currentValue = parseInt($(this).val());
        if(currentValue === 12) {
            showMessage();
        } else {
            hideMessage();
        }
    });

    var currentValue = parseInt($transaction_category.val());
    if(currentValue === 12) {
        showMessage();
    } else {
        hideMessage();
    }
}

$redeem_task_table = $('#reward-tasks-table');
if($redeem_task_table) {
    $redeem_task_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $redeem_task_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            {
                data: function(row) {
                    return "<a href='/admin/tasks/" + row.task_id + "'>" + row.task_name + "</a>";
                }
            },
            {
                data: function(row) {
                    return "<a href='/admin/users/" + row.user_id + "'>" + row.user_name + "</a>";
                }
            },
            { data: 'date' }
        ]
    });
}

$categories_table = $('#categories-table');
if($categories_table) {
    $categories_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $categories_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            { data: 'name' },
            { data: 'created_at' },
            { data: function(row){
                    return "<a href='/admin/categories/" + row.id + "/edit'>Edit</a>"
                }}
        ]
    });
}

$wallpapers_table = $('#wallpapers-table');
if($wallpapers_table) {
    $wallpapers_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $wallpapers_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            { data: 'name' },
            { data: 'created_at' },
            { data: function(row) {
                    return "<a href='/admin/categories/" + row.category_id + "'>" + row.category_name + "</a>";
                }}
        ]
    });
}

$you_tubes_table = $('#you-tubes-table');
if($you_tubes_table) {
    $you_tubes_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $you_tubes_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            { data: 'name' },
            { data: 'link' },
            { data: 'created_at' },
            { data: function(row) {
                    return "<a href='/admin/you_tubes/" + row.id + "/edit'>Edit</a>, <a href='/admin/you_tubes/" + row.id + "' data-method='delete' data-confirm='Are you sure?'>Delete</a>"
                }}
        ]
    })
}

$notifications_table = $('#notifications-table');
if($notifications_table) {
    $notifications_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $notifications_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            { data: 'message' },
            { data: 'created_at' },
            { data: function(row){
                    return "<a href='/admin/notifications/" + row.id + "' data-method='delete' data-confirm='Are you sure?'>Delete</a>";
                }}
        ]
    });
}

$custom_files_table = $('#custom-files-table');
if($custom_files_table.length) {
    var custom_files_table = $custom_files_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $custom_files_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            { data: 'name' },
            { data: 'file' },
            { data: 'created_at' },
            { data: function(row){
                    return "<a href='/admin/custom-files/" + row.id + "' data-method='delete' data-confirm='Are you sure?'>Delete</a>";
                }}
        ]
    });

    yadcf.init(custom_files_table, [
        { column_number: 1, filter_type: 'text' }
    ]);
}


$hollow_users_table = $('#hollow-users-table');
if($hollow_users_table) {
    $hollow_users_table.DataTable({
        processing: true,
        serverSide: true,
        ajax: $hollow_users_table.data('source'),
        pagingType: 'full_numbers',
        columns: [
            { data: 'id' },
            { data: 'email' },
            { data: 'mobile' },
            { data: 'name' },
            { data: 'refer_id' },
            { data: 'sponsor_id' },
            { data: 'real_sponsor_id' },
            { data: 'created_at' }
        ]
    });
}

$('.daterange').daterangepicker({
    locale: {
        format: 'DD/MM/YYYY'
    }
});