$(document).ready(function(){function disableSubmit(){$submitBtn.attr("disabled",!0),$(".course-quiz-honor-code-status").show(),$(".course-quiz-honor-code-thanks").hide(),$honorDiv.find("input[type=checkbox]").removeAttr("checked")}function enableSubmit(){$submitBtn.attr("disabled",!1),$(".course-quiz-honor-code-status").hide(),$(".course-quiz-honor-code-thanks").show(),$honorDiv.find("input[type=checkbox]").attr("checked","checked")}var whichButton="save_answers";$("input[name=save_answers]").click(function(){whichButton="save_buttons"}),$("input[name=save_answers]").focus(function(){whichButton="save_buttons"}),$("input[name=submit_answers]").click(function(){whichButton="submit_answers"}),$("input[name=submit_answers]").focus(function(){whichButton="submit_answers"}),$("#quiz_form").submit(function(event){if("submit_answers"===whichButton){var isConfirmed=confirm("Are you sure you want to submit your answers?");if(!isConfirmed)event.preventDefault()}});var $submitDiv=$(".course-quiz-submit-button-container"),$submitBtn=$submitDiv.find('input[name="submit_answers"]'),$honorDiv=$(".course-quiz-honor-code");if($honorDiv.length>0){var $honorCodeCheckbox=$honorDiv.find("input[type=checkbox]");$honorCodeCheckbox.click(function(){if($(this).prop("checked"))enableSubmit();else disableSubmit()}),disableSubmit()}var $proctored=$(".course-quiz-proctored");if($proctored.length>0){$proctored.on("paste drop",function(evt){evt.preventDefault()});var iePattern=/msie/i;if(iePattern.test(navigator.userAgent))$("body").on("selectstart",!1)}if("undefined"!=typeof QUIZ_TIME_REMAINING)var quiz_timer=new Quiz_Timer(Math.floor((new Date).getTime()/1e3)+Number(QUIZ_TIME_REMAINING),function(time_remaining){if(0>=time_remaining)if($submitBtn.is(":disabled")){var message="Time is up.\n\nIn accordance with the Honor Code, I certify that my answers here are my own work.";if(window.confirm(message)){if($honorCodeCheckbox)$honorCodeCheckbox.click();$submitBtn.attr("disabled",!1),$submitBtn.trigger("click")}}else $submitBtn.trigger("click")})});