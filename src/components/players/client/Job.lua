RedFW.Shared.Event:registerEvent("receiveJob", function(job, grade)
    RedFW.Client.Components.Player.job = job
    RedFW.Client.Components.Player.jobGrade = grade
    print(('^2Job %s with grade %s (salary : %i$) applied^0'):format(job.label, grade.label, grade.salary))
end)