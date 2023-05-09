current = [-100; -50; -10; 5; 10; 15; 20; 30; 40; 50; 75; 100];
field = [36.2; 18.2; 3.4; -1.6; -3.4; -5.4; -7.3; -11.1; -14.7; -18.2; -27.2; -36.2];

f = fit(current, field, 'poly1');
fprintf("field = %4.2f*current\n", f.p1);

figure;
plot(f, current, field, '.-');
xlabel("Current, mA");
ylabel("Field, G");
grid on;