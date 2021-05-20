function S = TimeT(E)
    xtime = seconds(E{:,1});
    S = table2timetable(E,"RowTimes",xtime);
    S(:,1) = [];
end

