RedFW.Shared.Event:registerEvent("receiveJob", function(job, jobGrade)
    RedFW.Client.Components.Player.job = job
    RedFW.Client.Components.Player.jobGrade = jobGrade
    print(('^2Job %s applied^0'):format(job))
end)