local tween = {}
tween.tweens = {}

local function getDifs(startT, endT)
	local difs = {}
	for k,v in pairs(startT) do
		if type(v) == "table" then
			difs[k] = getDifs(v, endT[k])
		elseif type(v) == "number" then
			difs[k] = endT[k] - v
		end
	end
	return difs
end

function tween.new(time, startT, endT)
	if time <= 0 then return end
	local t = {}
	t.time = time
	t.timeLeft = time*60

	t.vals = startT
	t.origVals = {}
	t.endVals = endT

	--Copy original values
	for k,v in pairs(t.vals) do
		t.origVals[k] = v
	end

	t.difs = getDifs(t.vals, t.endVals)


	--Delete anything tweening the current table
	for k, tw in pairs(tween.tweens) do
		if tw.vals == t.vals then
			table.remove(tween.tweens, k)
		end
	end
	table.insert(tween.tweens, t)
	return t
end

function tween.update(dt)
	for k, tw in pairs(tween.tweens) do
		tw.timeLeft = tw.timeLeft - 1
		for k, v in pairs(tw.vals) do
			if type(v) == "number" then
				local dif = tw.difs[k]
				local newVal = tw.vals[k] + (dif/tw.time)/60
				tw.vals[k] = newVal
			end
			if tw.timeLeft <= 0 then
				tw.vals[k] = tw.endVals[k]
			end
		end
		if tw.timeLeft <= 0 then
			tween.tweens[k] = nil
		end
	end
end

return tween